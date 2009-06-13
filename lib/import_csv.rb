class ImportCSV
  require 'fastercsv'
 
  DELETE_COUNT_THRESHOLD = 5
  DELETE_PERCENT_THRESHOLD = 0.6

  USER_HEADERS=[:id_district,:username,:first_name, :last_name, :middle_name, :suffix, :email,:passwordhash,:salt].to_set
  SCHOOL_HEADERS=[:id_district,:name].to_set
  STUDENT_HEADERS=[:id_state, :id_district, :number, :last_name, :first_name, :birthdate, :middle_name, :suffix, :esl, :special_ed].to_set
  
  STRIP_FILTER = lambda{ |field| field.strip}
  NULLIFY_FILTER = lambda{ |field| field == "NULL" ? nil : field}
  HEXIFY_FILTER  = lambda{ |field| hex=field.to_i(16).to_s(16); hex.length == 40 ? hex : field}

  DEFAULT_CSV_OPTS={:skip_blanks=>true, :headers =>true, :header_converters => [STRIP_FILTER,:symbol], :converters => [STRIP_FILTER,NULLIFY_FILTER,HEXIFY_FILTER]}


  FILE_ORDER = ['schools.csv', 'students.csv', 'users.csv']

  attr_reader :district, :messages, :filenames
  
  def initialize file, district
    @district=district
    @messages = []
    @file = file
    @f_path = "tmp/import_files/#{district.id}"
  end

  def import
    identify_and_unzip
    @filenames.sort_by {|e| ImportCSV::FILE_ORDER.index(e.downcase) || ImportCSV::FILE_ORDER.length + 1}.each {|f| process_file f}
    
    FileUtils.rm_rf @f_path
  end

  private

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
      @messages << "Problem with zipfile #{originalname}" unless
        system "unzip  -qq -o #{filename} -d #{@f_path}"
      @filenames = Dir.glob(File.join(@f_path, "*.csv")).collect
    else
      false
    end

  end




  def process_file file_name
    base_file_name = File.basename(file_name)

    case base_file_name.downcase
    when 'users.csv'
      load_users_from_csv file_name
    when 'schools.csv'
      load_schools_from_csv file_name
    when 'students.csv'
      load_students_from_csv file_name
    when 'enrollments.csv'
      load_enrollments_from_csv file_name
    else
      msg = "Unknown file #{base_file_name}"
    end

    @messages << msg

  end
      

  def self.clean_users file_name
  
    input = File.open 'tmp/e/users.csv', 'r'
    output = File.open 'tmp/e/clean_users.csv', 'w'
    FasterCSV.filter input, output, DEFAULT_OPDEFAULT_CSV_OPTS do |row|

         row.delete_if {true}   if row[0] =~  /^-+|\(\d+ rows affected\)$/   
    end
    input.close
    output.close

  end

  def self.load_district_admins_from_csv file_name, district
    @role=Role.find_by_name 'district_admin'
    @existing_users = @role.users.all(:conditions => ["district_id = ? and id_district is not null", district.id],:select => "id, id_district")
    id_districts_for_admins=[166669, 182393].compact
         
    @desired_users = district.users(true).all(:select => "id, id_district", 
    :conditions => ["district_id = ? and id_district is not null and id_district in (?) ", district.id,
    id_districts_for_admins])

    #insert desired - existing
    @role.users << (@desired_users  -@existing_users)
    
    #remove existing - desired
    @role.users.delete(@existing_users - @desired_users)
  end

  def load_schools_from_csv  file_name
    @schools=School.find_all_by_district_id(@district.id).inject({}) {|hsh,obj| hsh[obj.id_district]=obj; hsh}
    if load_from_csv file_name,  "school"
      @district.schools.scoped(:conditions => ["id_district is not null and id not in (?)", @ids]).destroy_all
      bulk_update 'School'
      bulk_insert 'School'
    else
      false
    end
  end

  def load_enrollments_from_csv  file_name
    @schools = School.find_all_by_district_id(@district.id).inject({}) {|hsh,obj| hsh[obj.id_district]=obj; hsh}
    @students = Student.find_all_by_district_id(@district.id).inject({}) {|hsh,obj| hsh[obj.id_state]=obj; hsh }
    if load_from_csv file_name,  "school"
      @district.schools.scoped(:conditions => ["id_district is not null and id not in (?)", @ids]).destroy_all
      bulk_update 'School'
      bulk_insert 'School'
    else
      false
    end
  end



  
 
  def load_students_from_csv file_name
    #136.140547037125 new import, 88 running it again
    
    @students = Student.find_all_by_district_id(@district.id).inject({}) {|hsh,obj| hsh[obj.id_state]=obj; hsh }
    if load_from_csv file_name, "student"
      #TODO deletion should only occur for students that have no activity
      @district.students.scoped(:conditions => ["id_district is not null and id not in (?)", @ids]).destroy_all
      bulk_update 'Student'
      bulk_insert 'Student'
    else
      false
    end
  end
    

  def load_users_from_csv file_name

    #with db
    #=> #<Benchmark::Tms:0x4344ffc8 @real=1669.30910181999, @utime=1398.7, @cstime=0.0, @cutime=0.0, @label="", @total=1593.06, @stime=194.36>
    #without db
    #=> #<Benchmark::Tms:0x426ad0b4 @real=22.8795781135559, @utime=22.8399999999999, @cstime=0.0, @cutime=0.0, @label="", @total=22.8699999999999, @stime=0.0300000000000011>
    # preloading existing users, splittng update and create to use w/o callbacks private methods
    #=> #<Benchmark::Tms:0x459f75b4 @real=260.481770992279, @utime=167.44, @cstime=0.0, @cutime=0.0, @label="", @total=202.95, @stime=35.51>

    # #<Benchmark::Tms:0x426fc4ac @real=87.2511579990387, @utime=85.85, @cstime=0.0, @cutime=0.0, @label="", @total=87.24, @stime=1.39> in production mode with inserts
    # all in a transactiona
    # @real=96.9692440032959 same as above, but in development.       all tests so far are using sqlite3

    #46 seconds when redoing duplicate file
    #131.687636852264 seconds for full update
    
    @users = User.find_all_by_district_id(@district.id).inject({}) {|hsh,obj| hsh[obj.username]=obj; hsh}
    if load_from_csv file_name,  "user"
      
        @district.users.scoped(:conditions => ["id_district is not null and id not in (?)",@ids]).destroy_all  #delete
        #TODO deletion should only occur for users that have no activity
        #delete must be before insert, since they don't have ids yet

        bulk_update 'User'  #update
        bulk_insert 'User'
    else
      false
    end
  end

  def bulk_insert klass_name
    klass_name.constantize.transaction do
      @inserts.each do |i|
        i.send(:create_without_callbacks)
      end
    end

  end

  def bulk_update klass_name
    klass_name.constantize.transaction do
      @updates.each do |obj|
        obj.send(:update_without_callbacks) if obj.changed?
      end
    end
  end
  


  def get_constant model_name
    constant_name = "#{model_name.upcase}_HEADERS"
     if ImportCSV.const_defined?(constant_name) 
      "ImportCSV::#{constant_name}".constantize
     else
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
    if  file_exists? file_name,model_name
      @constant=get_constant model_name
    end
  end

  def valid_lines? lines, model_name
    headers_match?(lines) and reasonable_size?(lines, model_name)
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
      return false unless valid_lines?(lines, model_name)

        @ids= []
        @updates = []
        @inserts = []

        lines.each do |line|
          next  if line[0] =~  /^-+|\(\d+ rows affected\)$/   
         #some CSV such as sql server appends a blank line and a rowcount
          self.send("process_#{model_name}_line", line)
        end

      @messages << "Successful import of #{File.basename(file_name)}"
    end
  end
  
  def process_user_line  line
    found_user = @users[line[:username]]  || @district.users.build
    process_line line, found_user
  end

  def process_school_line line
    found_school = @schools[line[:id_district].to_i] || @district.schools.build
    process_line line, found_school
  end

  def process_student_line line
    found_student = @students[line[:id_state].to_i] || @district.students.build
    process_line line, found_student
  end

  def process_enrollment_line
    found_enrollment = @enrollments[line[:id_district].to_i] || Enrollment.new
  end

  def process_line line,obj
    begin
      obj.attributes = line.to_hash
    rescue
      puts line.inspect
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
