module CSVImporter

  # == Schema Information
  # Schema version: 20090623023153
  #
  # Table name: students
  #
  #  id          :integer(4)      not null, primary key
  #  district_id :integer(4)
  #  last_name   :string(255)
  #  first_name  :string(255)
  #  number      :string(255)
  #  id_district :integer(4)
  #  id_state    :integer(4)
  #  id_country  :integer(4)
  #  created_at  :datetime
  #  updated_at  :datetime
  #  birthdate   :date
  #  esl         :boolean(1)
  #  special_ed  :boolean(1)
  #  middle_name :string(255)
  #  suffix      :string(255)
  #


  
  class Students < CSVImporter::Base
    #13.1196098327637 seconds of overhead for preprocessing the csv and loading into the temporary table (and indexing)
    #19.3717708587646,
=begin
    def import
     #use the existing temporary table
     insert_update_delete
     @messages.join(' ')
    end
=end
  private

                                  
    def index_options
      [:id_state, :id_district]
    end

    def csv_headers
     [:id_state, :id_district, :number, :last_name, :first_name, :birthdate, :middle_name, :suffix, :esl, :special_ed]
    end

    def sims_model
      Student
    end

    def migration t
      cols = sims_model.columns.inject({}){|hash, col| hash[col.name.to_sym] = col.type; hash}

      csv_headers.each do |col|
        t.column col, cols[col]
      end
    end

    def temporary_table?
      true
    end

    def insert_update_delete
      #update students s inner join students_546713874_importer ts on ts.id_state = s.id_state set district_id = 546713874 where s.district_id is null and ts.id_state is not null;

      ActiveRecord::Base.connection.execute("update #{temporary_table_name} set id_state = null where id_state = ''")

      reject_students_in_other_districts
      reject_students_with_nil_data_but_nonmatching_birthdate_or_last_name_if_birthdate_is_nil_on_one_side
      claim_students_with_nil_district
      update_students_already_in_district
      insert
      delete
    end

    def reject_students_in_other_districts
      q="select ts.id_state, ts.first_name, ts.last_name, s.district_id from #{temporary_table_name} ts inner join students s on 
          ts.id_state = s.id_state
          where s.district_id != #{@district.id} and s.district_id is not null 
          and s.id_state is not null and ts.id_state is not null"

      @rejected = ActiveRecord::Base.connection.select_all q

      @rejected.each do |reject|
        @messages << "Student with matching id_state: #{reject['id_state']}, #{reject['first_name']} #{reject['last_name']} is enrolled in another district #{District.find_by_id reject['district_id']}  You may need to contact that district, or the id_state could be incorrect."
      end
       q="delete from ts using #{temporary_table_name} ts inner join students s on 
          ts.id_state = s.id_state
          where s.district_id != #{@district.id} and s.district_id is not null 
          and s.id_state is not null"
          
       ActiveRecord::Base.connection.execute q
    end

    def reject_students_with_nil_data_but_nonmatching_birthdate_or_last_name_if_birthdate_is_nil_on_one_side
      shared="#{temporary_table_name} ts inner join students s on 
          ts.id_state = s.id_state
          where s.district_id is null and s.id_district is not null
          and s.id_state is not null
          and ((
            ts.birthdate != s.birthdate
            ) or (
              (ts.birthdate is null or s.birthdate is null)
              and ts.last_name != s.last_name
            ))"
      q="select ts.id_state, ts.first_name, ts.last_name from #{shared}"
      @rejected = ActiveRecord::Base.connection.select_all q
      @rejected.each do |reject|
        @messages << "Student with matching id_state: #{reject['id_state']}, #{reject['first_name']} #{reject['last_name']} could be claimed but does not appear to be the same student.  Please make sure the id_state is correct for this student, and if so contact the state administrator."
      end

      q="delete from ts using #{shared}"
      ActiveRecord::Base.connection.execute q
    end
    
    def claim_students_with_nil_district
      
      claimed_count = ActiveRecord::Base.connection.update_sql("update students s inner join #{temporary_table_name} ts on 
      ts.id_state = s.id_state set s.district_id = #{@district.id}, s.id_district = ts.id_district where s.district_id is null and ts.id_state is not null")
      @messages << "#{claimed_count} students claimed that had left another district" if claimed_count > 0
     
      #do select and add to messages
      # select * from students_546713874_importer ts inner join students s on ts.id_state = s.id_state
      # where s.district_id is null and ts.id_state is not null;

      #update students s set district_id = ? where district_id is null
      #  and exists (select * from tt where s.id_state = tt.id_state and tt.id_state is not null)

    end

    def update_students_already_in_district
      # def csv_headers
      # :number, :last_name, :first_name, :birthdate, :middle_name, :suffix, :esl, :special_ed]
      # end
       updates=csv_headers.collect{|e| "s.#{e} = ts.#{e}"}.join(", ")
             
      q="update students s inner join #{temporary_table_name} ts on 
          ts.id_district = s.id_district set s.updated_at = CURDATE(), #{updates}
          where s.district_id = #{@district.id} and s.id_district is not null"
      ActiveRecord::Base.connection.update_sql(q)
    end

    def delete
      #unset the district of  all students that are not in the temporary table
       q="update students s left outer join #{temporary_table_name} ts on 
          ts.id_district = s.id_district set s.district_id = null
          where s.district_id = #{@district.id} and ts.id_district is null and s.id_district is not null"
     
       ActiveRecord::Base.connection.update_sql(q)
       
      #prune the districtless students
      
      
      puts 'You still need to prune the existing students at some point'
      #      @messages << 'Shawn still needs to prune the existing students that are not in districts'

      #remove_students_in_district_not_in_temporary_table #delete_or_disable?  or just disable
      #Student.delete_all(:district_id => @district.id)
    end

    def insert
      inserts = csv_headers.join(", ")
      query=("insert into students
      (#{inserts}, created_at, updated_at, district_id)
      select ts.*, curdate(), curdate(), #{@district.id} from #{temporary_table_name} ts left outer join students s
      on ts.id_district = s.id_district and s.district_id = #{@district.id}
      where s.id_district is null and ts.id_district is not null
      "
      )

     
      ActiveRecord::Base.connection.execute query
    end

    def confirm_count?
      return true
      model_name = sims_model.name
    model_count = @district.send(model_name.tableize).count
    if @line_count < (model_count * ImportCSV::DELETE_PERCENT_THRESHOLD  ) && model_count > ImportCSV::DELETE_COUNT_THRESHOLD
      @messages << "Probable bad CSV file.  We are refusing to delete over 40% of your #{model_name.pluralize} records."
      false
    else
      true
    end
    end
 


  end
end
=begin


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
=end
