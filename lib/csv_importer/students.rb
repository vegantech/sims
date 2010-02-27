module CSVImporter

  
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
      [:id_state, :district_student_id]
    end

    def csv_headers
     [:id_state, :district_student_id, :number, :first_name, :middle_name, :last_name, :suffix, :birthdate,  :esl, :special_ed]
    end

    def sims_model
      Student
    end

    def migration t
      @cols = sims_model.columns.inject({}){|hash, col| hash[col.name.to_sym] = col.type; hash}
      @cols[:special_ed]=:string

      csv_headers.each do |col|
        t.column col, @cols[col]
      end
    end

    def temporary_table?
      true
    end

    def postprocess_uploaded_csv
      to_strip=csv_headers.select{|col| @cols[col] == :string || @cols[col] == :text}
      s= "update #{temporary_table_name} set #{to_strip.collect{|c| "#{c} = trim(#{c})"}.join(', ')},  
        special_ed = case special_ed when 'Y' then true when 'N' then false when 'n' then false when NULL then NULL else true end"
      
      
      
      ActiveRecord::Base.connection.execute(s)
      #" 

    end

    def insert_update_delete
      postprocess_uploaded_csv
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
          where s.district_id is null and s.district_student_id is not null
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
      ts.id_state = s.id_state or (ts.id_state is null and s.id_state is null) set s.district_id = #{@district.id}, s.district_student_id = ts.district_student_id where s.district_id is null and
                                                               (ts.id_state is not null or (ts.birthdate = s.birthdate and ts.first_name = s.first_name and 
                                                               ts.last_name = s.last_name and ts.birthdate is not null and ts.id_state is null and s.id_state is null ) ) ")
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
          ts.district_student_id = s.district_student_id set s.updated_at = CURDATE(), #{updates}
          where s.district_id = #{@district.id} and s.district_student_id is not null"
      ActiveRecord::Base.connection.update_sql(q)
    end

    def delete
      #unset the district of  all students that are not in the temporary table
       q="update students s left outer join #{temporary_table_name} ts on 
          ts.district_student_id = s.district_student_id set s.district_id = null
          where s.district_id = #{@district.id} and ts.district_student_id is null and s.district_student_id is not null"
     
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
      on ts.district_student_id = s.district_student_id and s.district_id = #{@district.id}
      where s.district_student_id is null and ts.district_student_id is not null
      "
      )

     
     ActiveRecord::Base.connection.update_sql(query)
    end

    def confirm_count?
      model_name = sims_model.name
      model_count = @district.send(model_name.tableize).count(:conditions=>'district_student_id is not null and district_student_id !=""')
      if @line_count < (model_count * ImportCSV::DELETE_PERCENT_THRESHOLD  ) && model_count > ImportCSV::DELETE_COUNT_THRESHOLD
        @messages << "Probable bad CSV file.  We are refusing to delete over 40% of your #{model_name.pluralize} records."
        false
      else
        true
      end
    end
 


  end
end

