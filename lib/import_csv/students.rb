module ImportCSV::Students  
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
    
    @students = Student.find_all_by_district_id(@district.id).hash_by(:id_state)
    if load_from_csv file_name, "student"
      #TODO deletion should only occur for students that have no activity
      #Student.scoped(:conditions => ["district_id = ? and id_district is not null and id not in (?)",@district.id, @ids]).destroy_all
      bulk_update Student
      students_ids = @students.values.collect(&:id)

      # Student.delete(students_ids - @ids)
      to_delete_or_disable = (students_ids - @ids)

      to_disable =student_ids_with_associations to_delete_or_disable
      to_delete = to_delete_or_disable - to_disable
      #      ,to_delete = to_delete_or_disable.partition{|i| Enrollment.exists?(:student_id => i)}

      Student.delete(to_delete)
      Student.update_all("district_id = null, id_district = null", "id in (#{to_disable})") unless to_disable.empty?
      #      Student.connection.execute "update students set (district_id, id_district) = (null, null) where students.id in (#{to_disable})"
      bulk_insert Student
    else
      false
    end
  end
  def process_student_line line
    found_student = @students[line[:id_state].to_i] || @district.students.build
    process_line line, found_student
  end


end

