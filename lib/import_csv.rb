class ImportCSV
  require File.expand_path 'lib/csv_importer/base_system_flags.rb'

  APPEND_FILE_MATCHER = /_append(s)?/
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
                "admins_of_schools.csv",
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
      @district.users.update_all(:updated_at => Time.now) #expire any user related cache
      @messages << "No csv files uploaded" if sorted_filenames.blank?
    end
    @messages << b
    @messages << EOF
    update_memcache
  end

  private
  def update_memcache
    Rails.cache.write("#{@district.id}_import", @messages.join("<br/ > "), expires_in: 120.minutes)
  end

  def process_file file_name
    base_file_name = File.basename(file_name)
    @messages << "Processing file: #{base_file_name}"
    update_memcache
    f = base_file_name.downcase.gsub(APPEND_FILE_MATCHER,'')
    case f
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
    base_file_name = File.basename(file_name).gsub(APPEND_FILE_MATCHER,'')
    c="CSVImporter/#{base_file_name.sub(/.csv/,'')}".classify.pluralize
    @messages << c.constantize.new(file_name,@district).import
  end

  def file_exists? file_name,model_name
    if File.exist?(file_name)
      true
    else
      @messages << "#{file_name} did not exist when attempting to load #{model_name.pluralize} from csv"
      false
    end

  end

  def sorted_filenames filenames=@filenames

    filenames.compact.sort_by do |f|
      2 * (FILE_ORDER.index(File.basename(f.downcase.gsub(APPEND_FILE_MATCHER,'')))  || FILE_ORDER.length) +
      (f.match(APPEND_FILE_MATCHER) ? 1 : 0)
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
        system "unzip -j -qq -o #{filename} -d #{@f_path}"
      @filenames = Dir.glob(File.join(@f_path, "*.csv"))
    else
      false
    end

  end

end
