class ImportCSV
  require 'hash_by'
  require 'fastercsv'
 
  DELETE_COUNT_THRESHOLD = 5
  DELETE_PERCENT_THRESHOLD = 0.6
  STRIP_FILTER = lambda{ |field| field.strip}
  NULLIFY_FILTER = lambda{ |field| field == "NULL" ? nil : field}
  HEXIFY_FILTER  = lambda{ |field| hex=field.to_i(16).to_s(16); hex.length == 40 ? hex : field}
  CLEAN_CSV_OPTS ={:converters => [STRIP_FILTER,:symbol]}
  DEFAULT_CSV_OPTS={:skip_blanks=>true, :headers =>true, :header_converters => [STRIP_FILTER,:symbol], :converters => [STRIP_FILTER,NULLIFY_FILTER,HEXIFY_FILTER]}
  SKIP_SIZE_COUNT = ['enrollment','system_flag','role', 'extended_profile']
 
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
      @messages << "No csv files uploaded" if sorted_filenames.blank? 
    end
    @messages << b
    update_memcache
  end

  private

  include  ImportCSV::FileHandling
  include  ImportCSV::ExtendedProfiles
  include  ImportCSV::Roles
  include  ImportCSV::SystemFlags

  def update_memcache
    begin
      if defined?MEMCACHE
        MEMCACHE.set("#{@district.id}_import", @messages.join("<br/ > "), 30.minutes)
      end
    rescue 
      nil
    end

  end

  def process_file file_name
    base_file_name = File.basename(file_name)
    if Object.const_defined?'SIMS_DOMAIN' and ::SIMS_DOMAIN == 'simspilot.org'
      #@messages << 'Still working on imports.'
      #      return false
    end
    @messages << "Processing file: #{base_file_name}"
    update_memcache
    f = base_file_name.downcase
    

    case base_file_name.downcase
    when 'district_admins.csv'
      load_user_roles_from_csv file_name, 'district_admin'
    when 'news_admins.csv'
      load_user_roles_from_csv file_name, 'news_admin'
    when 'content_admins.csv'
      load_user_roles_from_csv file_name, 'content_admin'
    when 'school_admins.csv'
      load_user_roles_from_csv file_name, 'school_admin'
    when 'regular_users.csv'
      load_user_roles_from_csv file_name, 'regular_user'
    when 'system_flags.csv'
      load_system_flags_from_csv file_name
    when *csv_importers(file_name)
      csv_importer file_name
    else
      msg = "Unknown file #{base_file_name}"
    end

    @messages << msg
    update_memcache
  end

  def csv_importers file_name
    ["enrollments.csv", "schools.csv", "students.csv", "groups.csv", "user_groups.csv", "student_groups.csv", "users.csv", 
    "all_schools.csv", "all_students_in_district.csv","all_students_in_school.csv", "user_school_assignments.csv", "staff_assignments.csv",
    "ext_arbitraries.csv", "ext_siblings.csv", "ext_adult_contacts.csv", "ext_test_scores.csv", "ext_summaries.csv"]
  end

  def csv_importer file_name
    
    base_file_name = File.basename(file_name)
    c="CSVImporter/#{base_file_name.sub(/.csv/,'')}".classify.pluralize
    puts c
    @messages << c.constantize.new(file_name,@district).import
  end
    
    

  def ids_by_id_district klass
    klass.connection.select_all("select id, id_district from #{klass.table_name} where district_id = #{@district.id}").hash_by("id_district", "id", :to_i=>true)
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
      @messages << "Probable bad CSV file.  We are refusing to delete over 40% of your #{model_name.pluralize} records."
      false
    else
      true
    end
 
  end

  def headers_match? lines
    if @constant.to_set ==lines.headers.to_set  #expected headers are present in any order with no extra ones
      true
    else
      @messages <<  "invalid header #{lines.headers.inspect} it should be #{@constant.to_set.inspect}"
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
end
