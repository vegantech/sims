module ImportCSV
  require 'fastercsv'
 
  DELETE_COUNT_THRESHOLD = 5
  DELETE_PERCENT_THRESHOLD = 0.6

  USER_HEADERS=[:id_district,:username,:first_name, :last_name, :middle_name, :suffix, :email,:passwordhash,:salt].to_set
  SCHOOL_HEADERS=[:id_district,:name].to_set
  STUDENT_HEADERS=[:id_state, :id_district, :number, :last_name, :first_name, :birthdate, :middle_name, :suffix, :esl, :special_ed].to_set
  
  @strip = lambda{ |field| field.strip}
  @nullify = lambda{ |field| field == "NULL" ? nil : field}
  @hexify = lambda{ |field| hex=field.to_i(16).to_s(16); hex.length == 40 ? hex : field}

  @opts={:skip_blanks=>true, :headers =>true, :header_converters => [@strip,:symbol], :converters => [@strip,@nullify,@hexify]}




  def self.process_file file_name, district
    base_file_name = File.basename(file_name)

    msg ="Processed #{base_file_name}"
    case base_file_name
    when 'users.csv'
      load_users_from_csv file_name, district
    else
      msg = "Unknown file #{base_file_name}"
    end

    msg

  end
      
   

  def self.process_zip file_name, district
    f_path = "tmp/import_files/#{district.id}"
    FileUtils.mkdir_p(File.dirname(f_path))
    system "unzip  -qq -o #{file_name} -d #{f_path}"

    res=Dir.glob(File.join(f_path, "*.csv")).collect do |file|
      process_file file, district
    end

    FileUtils.rm_rf f_path

    res.join("\n")
    
  end

  def self.clean_users file_name
  
    input = File.open 'tmp/e/users.csv', 'r'
    output = File.open 'tmp/e/clean_users.csv', 'w'
    FasterCSV.filter input, output, @opts do |row|

         row.delete_if {true}   if row[0] =~  /^-+|\(\d+ rows affected\)$/   
    end
    input.close
    output.close

  end

  def self.load_district_admins_from_csv file_name, district


    @role=Role.find_by_name 'district_admin'
    @existing_users = @role.users.all(:conditions => ["district_id = ? and id_district is not null", district.id],:select => "id, id_district")
    id_districts_for_admins=[166669, 182393].compact
         
    @desired_users = district.users.all(:select => "id, id_district", 
    :conditions => ["district_id = ? and id_district is not null and id_district in (?) ", district.id,
    id_districts_for_admins])

    #insert desired - existing
    @role.users << (@desired_users  -@existing_users)
    
    #remove existing - desired
    @role.users.delete(@existing_users - @desired_users)
   
    
    

    
    
  end

  def self.load_schools_from_csv  file_name, district
    @schools=School.find_all_by_district_id(district.id).inject({}) {|hsh,obj| hsh[obj.id_district]=obj; hsh}
    if load_from_csv file_name, district, "school"
      district.schools.scoped(:conditions => ["id_district is not null and id not in (?)", @ids]).destroy_all
    else
      false
    end
  end

  
 
  def self.load_students_from_csv file_name, district
    @students = district.students.inject({}) {|hsh,obj| hsh[obj.id_state]=obj; hsh }
    if load_from_csv file_name, district, "student"
      district.students.scoped(:conditions => ["id_district is not null and id not in (?)", @ids]).destroy_all
    else
      false
    end
  end
    

  def self.load_users_from_csv file_name, district

    #with db
    #=> #<Benchmark::Tms:0x4344ffc8 @real=1669.30910181999, @utime=1398.7, @cstime=0.0, @cutime=0.0, @label="", @total=1593.06, @stime=194.36>
    #without db
    #=> #<Benchmark::Tms:0x426ad0b4 @real=22.8795781135559, @utime=22.8399999999999, @cstime=0.0, @cutime=0.0, @label="", @total=22.8699999999999, @stime=0.0300000000000011>
    # preloading existing users, splittng update and create to use w/o callbacks private methods
    #=> #<Benchmark::Tms:0x459f75b4 @real=260.481770992279, @utime=167.44, @cstime=0.0, @cutime=0.0, @label="", @total=202.95, @stime=35.51>

    # #<Benchmark::Tms:0x426fc4ac @real=87.2511579990387, @utime=85.85, @cstime=0.0, @cutime=0.0, @label="", @total=87.24, @stime=1.39> in production mode with inserts
    # all in a transactiona
    # @real=96.9692440032959 same as above, but in development.       all tests so far are using sqlite3

    
    
    @users = User.find_all_by_district_id(district.id).inject({}) {|hsh,obj| hsh[obj.username]=obj; hsh}
    if load_from_csv file_name, district, "user"
      #  @updates.each{|i| i.send(:update_without_callbacks); puts 'update'}
        district.users.scoped(:conditions => ["id_district is not null and id not in (?)",@ids]).destroy_all  #delete
        #delete must be before insert, since they don't have ids yet
        
        User.transaction do
          @inserts.each do |i|
           i.send(:create_without_callbacks)
         end
        end
    else
      false
    end
  end

  def self.load_from_csv file_name, district, model_name
    
    constant_name = "#{model_name.upcase}_HEADERS"
    puts "invalid object" and return false unless ImportCSV.const_defined?(constant_name)
    
    constant = "ImportCSV::#{constant_name}".constantize

    if File.exist?(file_name)
      lines = FasterCSV.read(file_name, @opts)
    
      
      if constant.to_set ==lines.headers.to_set  #expected headers are present in any order with no extra ones
        model_count = district.send(model_name.pluralize).count
        
        if lines.length < (model_count * DELETE_PERCENT_THRESHOLD  ) && model_count > DELETE_COUNT_THRESHOLD
          puts "Probable bad CSV file.  We are refusing to delete over 40% of your #{model_name.pluralize} records."
          return false
        end
 
        @ids= []
        @updates = []
        @inserts = []

        lines.each do |line|
          next  if line[0] =~  /^-+|\(\d+ rows affected\)$/   
         #some CSV such as sql server appends a blank line and a rowcount
          self.send("process_#{model_name}_line", district, line)
        end
      else
        puts "invalid header #{lines.headers.inspect}"
        return false
      end
    else
      puts("#{file_name} did not exist when attempting to load #{model_name.pluralize} from csv")
      return false
    end
    true
  end
  
  def self.process_user_line district, line
    found_user = @users[line[:username]]  || district.users.build
    process_line line, found_user
  end

  def self.process_school_line district,line
    found_school = @schools[line[:id_district].to_i] || district.schools.build
    process_line line, found_school
  end

  def self.process_student_line district,line
    found_student = @students[line[:id_state].to_i] || district.students.build
    process_line line, found_student

  end

  def self.process_line line,obj
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
      obj.send(:update_without_callbacks) if obj.changed?
    end
    @ids << obj.id


  end
   

  def self.starts_with?(should_start_with, candidate)
    candidate[0..(should_start_with.length-1)] == should_start_with
  end
end
