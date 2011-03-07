class ImportCSV
  require 'hash_by'
  require 'fastercsv'
  require 'lib/csv_importer/base_system_flags'

  DELETE_COUNT_THRESHOLD = 5
  DELETE_PERCENT_THRESHOLD = 0.3
  STRIP_FILTER = lambda{ |field| field.to_s.strip}
  NULLIFY_FILTER = lambda{ |field| field == "NULL" ? nil : field}
  HEXIFY_FILTER  = lambda{ |field| hex=field.to_i(16).to_s(16); hex.length == 40 ? hex : field}
  CLEAN_CSV_OPTS ={:converters => [STRIP_FILTER,:symbol]}
  DEFAULT_CSV_OPTS={:skip_blanks=>true, :headers =>true, :header_converters => [STRIP_FILTER,:symbol], :converters => [STRIP_FILTER,NULLIFY_FILTER,HEXIFY_FILTER]}
  SKIP_SIZE_COUNT = ['enrollment','system_flag','role', 'extended_profile']
  EOF = '@@END UPLOAD RESULTS@@'

  FILE_ORDER = ['schools.csv', 'students.csv', 'users.csv', 'groups.csv','system_flags.csv', 'user_school_assignments.csv']

  VALID_FILES= ["enrollments.csv", "schools.csv", "students.csv", "groups.csv", "user_groups.csv", "student_groups.csv", "users.csv", 
    "all_schools.csv", "all_students_in_district.csv","all_students_in_school.csv", "user_school_assignments.csv", "staff_assignments.csv",
    "ext_arbitraries.csv", "ext_siblings.csv", "ext_adult_contacts.csv", "ext_test_scores.csv", "ext_summaries.csv",
    "district_admins.csv","news_admins.csv", "content_admins.csv", "school_admins.csv", "regular_users.csv", "system_flags.csv",
    *Flag::FLAGTYPES.keys.collect{|e| "#{e}_system_flags.csv"}
    ]

  def self.importers
    VALID_FILES.sort.collect do |csv_file|
      "CSVImporter::#{csv_file.split('.').first.classify.pluralize}".constantize
    end
  end

  def self.importer_from_symbol(key)
   "CSVImporter::#{key.to_s.classify.pluralize}".constantize
  end

  @@file_handlers={}

  attr_reader :district, :messages, :filenames
  
  def initialize file, district
    @district = district
    @messages = []
    @file = file
    @f_path = "tmp/import_files/#{district.id}"
  end

  def import
    b= Benchmark.measure do 
      identify_and_unzip
      sorted_filenames.each {|f| process_file f}
      FileUtils.rm_rf @f_path
      @district.students.update_all(:updated_at => Time.now) #expire any student related cache
      @messages << "No csv files uploaded" if sorted_filenames.blank? 
    end
    @messages << b
    @messages << EOF
    update_memcache
  end

  private

  include  ImportCSV::SystemFlags

  def update_memcache
    begin
      if defined?MEMCACHE
        MEMCACHE.set("#{@district.id}_import", @messages.join("<br/ > "), 120.minutes)
      end
    rescue 
      nil
    end

  end

  def process_file file_name
    base_file_name = File.basename(file_name)
    @messages << "Processing file: #{base_file_name}"
    update_memcache
    f = base_file_name.downcase
    

    case base_file_name.downcase
    when 'system_flags.csv'
      load_system_flags_from_csv file_name
    when *Flag::TYPES.keys.collect{|e| "#{e}_system_flags.csv"}
      load_system_flags_from_csv file_name
    when *csv_importers
      csv_importer file_name
    else
      msg = "Unknown file #{base_file_name}"
    end

    @messages << msg
    update_memcache
  end

  def csv_importers 
    VALID_FILES
  end

  def csv_importer file_name
    
    base_file_name = File.basename(file_name)
    c="CSVImporter/#{base_file_name.sub(/.csv/,'')}".classify.pluralize
    @messages << c.constantize.new(file_name,@district).import
  end
    
    

  def ids_by_id_district klass
    klass.connection.select_all("select id, district_#{klass.name.downcase}_id as id_district from #{klass.table_name} where district_id = #{@district.id}").hash_by("id_district", "id", :to_i=>false)
  end

  
    
  def bulk_insert klass
    klass.transaction do
      @inserts.each do |i|
        i.send(:create_without_callbacks)
      end
    end

  end

  def bulk_update klass
    klass.transaction do
      @updates.each do |obj|
        obj.send(:update_without_callbacks) if obj.changed?
      end
    end
  end
  


  def get_constant model_name
    begin
      obj = Kernel.const_get model_name.downcase.classify
      obj.const_get('CSV_HEADERS')
    rescue NameError
      @messages <<  "invalid object #{model_name}" 
      false 
    end
  end
  
  def file_exists? file_name,model_name
    
    if File.exist?(file_name)
      true
    else
      @messages << "#{file_name} did not exist when attempting to load #{model_name.pluralize} from csv"
      false
    end

  end

  def validate_params_and_set_constant file_name, model_name
    if file_exists? file_name, model_name
      @constant = get_constant model_name
    end
  end

  def valid_lines? lines, model_name
    headers_match?(lines) and (SKIP_SIZE_COUNT.include?(model_name) or reasonable_size?(lines, model_name))
  end

  def reasonable_size?(lines, model_name)
    model_count = @district.send(model_name.pluralize).count
    if lines.length < (model_count * DELETE_PERCENT_THRESHOLD  ) && model_count > DELETE_COUNT_THRESHOLD
      @messages << "Probable bad CSV file.  We are refusing to delete over 80% of your #{model_name.pluralize} records."
      false
    else
      true
    end
 
  end

  def headers_match? lines
    if @constant.to_set ==lines.headers.to_set  #expected headers are present in any order with no extra ones
      true
      elsif @category
        if lines.headers.to_set==[:district_student_id,:reason].to_set
          true
        else
         @messages <<  "invalid header #{lines.headers.inspect} it should be district_student_id,reason for #{@category}"
          false
        end

      else
      @messages <<  "invalid header #{lines.headers.inspect} it should be #{@constant.to_set.inspect} for #{@constant}"
      false
    end
  end
  
  def load_from_csv file_name, model_name
    validate_params_and_set_constant file_name, model_name
    
    if @constant
      lines = FasterCSV.read(file_name, DEFAULT_CSV_OPTS)
      if model_name != "enrollment"  # TODO THIS IS A HACK FOR NOW
        return false unless valid_lines?(lines, model_name) 
      end
      
      @ids= []
      @updates = []
      @inserts = []

      lines.each do |line|
        next  if line[0] =~  /^-+|\(\d+ rows affected\)$/   
       # some CSV such as sql server appends a blank line and a rowcount
        self.send("process_#{model_name}_line", line)
      end

      @messages << "Successful import of #{File.basename(file_name)}"
    end
  end
  

  def process_line line,obj
    begin
      obj.attributes = line.to_hash
    rescue
      @messages <<  "problem with #{line.inspect}, not imported"
    end
    if obj.new_record?
      obj.updated_at = Time.now if obj.respond_to?(:updated_at)
      obj.created_at = Time.now if obj.respond_to?(:created_at)
      @inserts.push obj
    else
      @updates.push obj
      @ids << obj.id
    end


  end
   

  def self.starts_with?(should_start_with, candidate)
    candidate[0..(should_start_with.length-1)] == should_start_with
  end




  def sorted_filenames filenames=@filenames

    filenames.compact.sort_by do |f|
      FILE_ORDER.index(File.basename(f.downcase))  ||
      FILE_ORDER.length + 1
    end
  end

  def identify_and_unzip
    FileUtils.mkdir_p(@f_path)
    if @file.respond_to?(:original_filename)
      try_to_unzip(@file.path, @file.original_filename) or move_to_import_directory
    else  #passed in a string
      try_to_unzip(@file, @file) or @filenames =[@file]
    end
  end

  def move_to_import_directory
    base_filename = File.basename(@file.original_filename)
    new_filename= File.join(@f_path,base_filename)
    FileUtils.mv @file.path,new_filename
    @filenames = [new_filename]
  end

  #string nonzip
  #string zip
  #file nonzip
  #file zip


  def try_to_unzip filename, originalname
    if originalname =~ /\.zip$/
      @messages << "Trying to unzip #{originalname}"
      update_memcache

      @messages << "Problem with zipfile #{originalname}" unless
        system "unzip  -qq -o #{filename} -d #{@f_path}"
      @filenames = Dir.glob(File.join(@f_path, "*.csv")).collect
    else
      false
    end

  end

end
