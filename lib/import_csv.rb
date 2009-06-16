class ImportCSV
  require 'fastercsv'
 
  DELETE_COUNT_THRESHOLD = 5
  DELETE_PERCENT_THRESHOLD = 0.6
  STRIP_FILTER = lambda{ |field| field.strip}
  NULLIFY_FILTER = lambda{ |field| field == "NULL" ? nil : field}
  HEXIFY_FILTER  = lambda{ |field| hex=field.to_i(16).to_s(16); hex.length == 40 ? hex : field}

  DEFAULT_CSV_OPTS={:skip_blanks=>true, :headers =>true, :header_converters => [STRIP_FILTER,:symbol], :converters => [STRIP_FILTER,NULLIFY_FILTER,HEXIFY_FILTER]}
  FILE_ORDER = ['schools.csv', 'students.csv', 'users.csv']
  SKIP_SIZE_COUNT = ['enrollment','system_flag','role']
  
 


  attr_reader :district, :messages, :filenames
  
  def initialize file, district
    @district = district
    @messages = []
    @file = file
    @f_path = "tmp/import_files/#{district.id}"
  end

  def import
    identify_and_unzip
    sorted_filenames.each {|f| process_file f}
    
    FileUtils.rm_rf @f_path
  end

  private

  def sorted_filenames filenames=@filenames
    filenames.sort_by do |f|
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
      @messages << "Problem with zipfile #{originalname}" unless
        system "unzip  -qq -o #{filename} -d #{@f_path}"
      @filenames = Dir.glob(File.join(@f_path, "*.csv")).collect
    else
      false
    end

  end




  def process_file file_name
    base_file_name = File.basename(file_name)
    if Kernel.const_defined?'SIMS_DOMAIN' and ::SIMS_DOMAIN == 'simspilot.org'
      @messages = 'Still working on imports.'
      return false
    end

    case base_file_name.downcase
    when 'users.csv'
      load_users_from_csv file_name
      when 'schools.csv'
      load_schools_from_csv file_name
    when 'students.csv'
      load_students_from_csv file_name
    when 'enrollments.csv'
      load_enrollments_from_csv file_name
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
      #    when 'system_flags.csv'
      #load_system_flags_from_csv file_name
    else
      msg = "Unknown file #{base_file_name}"
    end

    @messages << msg

  end

     
  def load_user_roles_from_csv file_name, role
    @role=Role.find_by_name(role) or return false
    @existing_users = @role.users.all(:conditions => ["district_id = ? and id_district is not null", @district.id],:select => "id, id_district")
    
    if load_from_csv file_name, "role"
      @desired_users = district.users(true).all(:select => "id, id_district", 
        :conditions => ["district_id = ? and id_district is not null and id_district in (?) ", @district.id,
        @ids.compact]
        )
      
      #insert desired - existing
      @role.users << (@desired_users  -@existing_users)
      
      #remove existing - desired
      @role.users.delete(@existing_users - @desired_users)
    end
      
  end


  def ids_by_id_district klass
    klass.connection.select_all("select id, id_district from #{klass.table_name} where district_id = #{@district.id}").inject({}) do |hsh,obj| 
      hsh[obj["id_district"].to_i]=obj["id"].to_i
      
       hsh
    end
  end

  def load_system_flags_from_csv file_name
    @student_ids_by_id_district = ids_by_id_district Student
    if load_from_csv file_name, 'system_flag'
      SystemFlag.scoped(:include => :student, :conditions => ["students.district_id => ? and students.id_district is not null", @district.id]).delete_all
      bulk_insert 'SystemFlag'
    end
  end

  
  def load_enrollments_from_csv  file_name
    #<Benchmark::Tms:0x430d52a8 @real=144.996875047684, @utime=141.65, @cstime=0.0, @cutime=0.0, @label="", @total=144.78, @stime=3.13>  all insert
    #<Benchmark::Tms:0x45067ecc @real=74.2686920166016, @utime=73.64, @cstime=0.0, @cutime=0.0, @label="", @total=74.14, @stime=0.5>  noop
    #<Benchmark::Tms:0x450a3b70 @real=149.988860845566, @utime=148.22, @cstime=0.0, @cutime=0.0, @label="", @total=149.86, @stime=1.64> 1/2 insert 1/2 update
    
    enrollments_from_db = Enrollment.all(:select => 'students.id_district as student_id_district, schools.id_district as school_id_district, enrollments.*',:joins=>[:student,:school],
    :conditions => ["schools.id_district is not null and schools.district_id = :district_id and students.id_district is not null and students.district_id = :district_id",
    {:district_id => @district.id}])
    
    @enrollments = enrollments_from_db.inject({}) do |hsh,obj| 
        hash_key_array = [obj[:student_id_district].to_i,obj[:school_id_district].to_i,obj[:end_year],obj[:grade]]
        
        hsh[ hash_key_array ] = obj[:id] ; hsh
      end
    

    @school_ids_by_id_district = ids_by_id_district School
    @student_ids_by_id_district = ids_by_id_district Student

    if load_from_csv file_name, "enrollment"
      #delete from search above where id not in @updates
      deletes = @enrollments.values - @updates
      Enrollment.delete(deletes)

      bulk_insert 'Enrollment'
    end
        
  end

  def process_enrollment_line line
    student_id_district =  line[:student_id_district].to_i
    school_id_district =  line[:school_id_district].to_i
    grade = line[:grade]
    end_year = line[:end_year].to_i
    hash_key= [student_id_district, school_id_district, end_year, grade]

    
    found_enrollment_id = @enrollments[hash_key]
    if found_enrollment_id
      @updates << found_enrollment_id
    else
      student_id = @student_ids_by_id_district[student_id_district]
      school_id = @school_ids_by_id_district[school_id_district]
      @inserts << Enrollment.new(:student_id => student_id, :school_id =>school_id, :grade => grade, :end_year => end_year)
    end
  end



  def process_system_flags_line
    category = line[:category].downcase
    student_id_district =  line[:student_id_district].to_i
    if flag:FLAGTYPES.keys.include?(category)
      student_id = @student_ids_by_id_district[student_id_district]
      @inserts << SystemFlag.new(:student_id => student_id, :category => category, :reason => line[:reason])
      
      
    end
  end



  

  def student_ids_with_associations ids=[]
   has_many = Student.reflect_on_all_associations(:has_many).select{|e| e.source_reflection.blank?}
   habtm = Student.reflect_on_all_associations(:has_and_belongs_to_many)

   table_names = []

   has_many.each{|e| table_names << e.table_name}
   habtm.each{|e| table_names << e.options[:join_table]}
   table_names.uniq!
   
    Student.all( 
      :group => 'students.id',
      :select => "students.id", 
      :joins => table_names.collect{|tn| "left outer join #{tn} on students.id = #{tn}.student_id"}.join(" "), 
      :having => table_names.collect{|tn| "count(#{tn}.student_id) >0"}.join(" or "),
      :conditions => {:id => ids}
      ).collect(&:id)

  end

  
 
  def load_students_from_csv file_name
    #136.140547037125 new import, 88 running it again
    
    @students = Student.find_all_by_district_id(@district.id).inject({}) {|hsh,obj| hsh[obj.id_state]=obj; hsh }
    if load_from_csv file_name, "student"
      #TODO deletion should only occur for students that have no activity
      #Student.scoped(:conditions => ["district_id = ? and id_district is not null and id not in (?)",@district.id, @ids]).destroy_all
      bulk_update 'Student'
      students_ids = @students.values.collect(&:id)

      # Student.delete(students_ids - @ids)
      to_delete_or_disable = (students_ids - @ids)

      to_disable =student_ids_with_associations to_delete_or_disable
      to_delete = to_delete_or_disable - to_disable
      #      ,to_delete = to_delete_or_disable.partition{|i| Enrollment.exists?(:student_id => i)}

      Student.delete(to_delete)
      Student.update_all("district_id = null, id_district = null", "id in (#{to_disable})")
      #      Student.connection.execute "update students set (district_id, id_district) = (null, null) where students.id in (#{to_disable})"
      bulk_insert 'Student'
    else
      false
    end
  end
 
  def load_schools_from_csv file_name
    @schools = School.find_all_by_district_id(@district.id).inject({}) {|hsh,obj| hsh[obj.id_district]=obj; hsh }
    if load_from_csv file_name, 'school'
      @district.schools.scoped(:conditions => ["id_district is not null and id not in (?)",@ids]).destroy_all
      bulk_update 'School'
      bulk_insert 'School'
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
      
        bulk_update 'User'  #update
        @district.users.scoped(:conditions => ["id_district is not null and id not in (?)",@ids]).destroy_all  #delete
        #TODO deletion should only occur for users that have no activity
        #delete must be before insert, since they don't have ids yet

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
    if  file_exists? file_name,model_name
      @constant=get_constant model_name
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
      if model_name != "enrollment"  #TODO THIS IS A HACK FOR NOW
        return false unless valid_lines?(lines, model_name) 
      end
      

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

  def process_role_line line
    @ids << line[:id_district]
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
