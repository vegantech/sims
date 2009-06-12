#students took 7 minutes
#enrollments took 11 minutes,    db creates are 10 minutes of that












































def load_users_from_mmsd

#id_district,username,first_name,last_name,middle_name,suffix,email,passwordhash,salt    
  
  @district = District.find_by_abbrev 'mmsd'
  users=@district.users
  user_lines = FasterCSV.read("tmp/e/users.csv")
  @user_lines = user_lines[2..-3]

  #id_district, name
  @user_lines.each do |user_line|
    id_district = user_line[0].to_s.strip.to_i
    username=user_line[1].strip.downcase
    first=user_line[2].strip
    last=user_line[3].strip
    middle=user_line[4].strip
    suffix=user_line[5].strip
    email=user_line[6].strip
    passwordhash=user_line[7].strip.to_i(16).to_s(16)
    salt=user_line[8].strip
    u=@district.users.build(:id_district => id_district, :username => username, :first_name => first, :middle_name => middle, 
    :last_name => last, :suffix => suffix, :email => email, :passwordhash => passwordhash, :salt => salt)
    u.send(:create_without_callbacks) 
    
  end
 
  #.to_i(16).to_s(16)
end



def load_enrollments_from_mmsd


  #grade,school_id_state,student_id_district

  #How do I delete or update?
  @district = District.find_by_abbrev 'mmsd'
  district_students = Student.find_all_by_district_id(@district.id, :select => "id_district,id" )
  student_ids_by_id_district= district_students.inject({}){|hash, student| hash[student.id_district]=student.id;hash}

  schools=School.find_all_by_district_id(@district.id, :select => "id_district, id")
  school_ids_by_id_district= schools.inject({}){|hash, school| hash[school.id_district]=school.id; hash}

  enrollment_lines = FasterCSV.read("tmp/e/enrollments.csv")

  valid_school_ids = @district.school_ids

  @enrollment_lines = enrollment_lines[2..-3]

  @enrollment_lines.each do |enrollment_line|
    grade = enrollment_line[0].to_s.strip
    year = enrollment_line[3].to_s.strip
    school_id = school_ids_by_id_district[enrollment_line[1].strip.to_i]
    student_id = student_ids_by_id_district[enrollment_line[2].strip.to_i]

    Enrollment.new(:school_id => school_id, :student_id => student_id, :grade => grade, :end_year => year) if valid_school_ids.include? school_id and student_id.present?
  end
  

end

def load_students_from_mmsd
  # Student.all
  @district = District.find_by_abbrev 'mmsd'
  district_students = Student.find_all_by_district_id(@district.id)

  students_by_id_state = {}
  district_students.each do |s|
    students_by_id_state[s.id_state] = s
  end

  student_lines = FasterCSV.read("tmp/e/students.csv");nil
  @student_header = student_lines.first
  #["id_state       ", "id_district", "number         ", "last_name                               ", "first_name                         ", "birthdate           ", "middle_name", "suffix"]
   
  @student_lines = student_lines[2..-3]

  student_ids_in_csv =[]

  @student_lines.each do |student_line|
     if student_line[0].strip == 'NULL'
       id_state =nil
     else
       id_state = student_line[0].to_i
     end
     id_district = student_line[1].to_i
     number = student_line[2].strip
     last_name = student_line[3].strip
     first_name = student_line[4].strip
     middle_name = student_line[6].strip
     suffix = student_line[7].strip
     if student_line[5].strip == 'NULL'
       birthdate = nil
     else
       begin
        birthdate = student_line[5].to_date
      rescue
        puts "FAIL, student_line is #{student_line.inspect}"
        birthdate = nil
      end
     end
   
     
     if id_state 
       # student = @district.students.find_by_id_state(id_state)
       student = students_by_id_state[id_state]
     else
       next #skip students with no id_state
     end
     

     
     student ||= @district.students.build(:id_state => id_state)
     
     student.id_district = id_district
     student.number = number
     student.last_name = last_name
     student.first_name = first_name
     student.birthdate=birthdate
     student.middle_name = middle_name
     student.suffix = suffix

     student.save(false)
     student_ids_in_csv << student.id
     
   end

   nil

   #   @district.student_ids = student_ids_in_csv
   
   

   


end
