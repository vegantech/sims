require 'fastercsv'
def load_students_from_mmsd
   student_lines = FasterCSV.read("/home/shawn/students.csv");nil
   @student_header = student_lines.first
   #["id_state       ", "id_district", "number         ", "last_name                               ", "first_name                         ", "birthdate           "]
   
   @student_lines = student_lines[2..-3]

   student_ids_in_csv =[]

   @district = District.find_by_abbrev 'mmsd'
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
       student = @district.students.find_by_id_state(id_state)
     else
       next #skip students with no id_state
     end
     

     
     student ||= @district.students.build(:id_state => id_state)
     
     student.id_district = id_district
     student.number = number
     student.last_name = last_name
     student.first_name = first_name
     student.birthdate=birthdate

     student.save(false)
     student_ids_in_csv << student.id
     
   end

   nil

   #   @district.student_ids = student_ids_in_csv
   
   

   


end
