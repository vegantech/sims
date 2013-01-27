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
    FIELD_DESCRIPTIONS = {
        :id_state =>"WSLS# (or other state id for student)",
        :district_student_id =>"Key used by district for student (40 char limit)",
        :number =>"Student number that would appear on report card or student id card.",
        :first_name =>"First name of student.",
        :middle_name =>"Middle name (or initial) of student.",
        :last_name =>"Last name of student.",
        :suffix =>"Suffix of student (jr. III).",
        :birthdate =>"Date of Birth  (YYYY-MM-DD or MM/DD/YYYY)",
        :esl =>"true if student is considered English as a Second Language  (false or blank if not Y/N also works).  You can also use the language proficiency here.  Values 1-6 will be true,  7 is false.  ",
        :special_ed =>"true if student is in Special Educatin (false or blank if not Y/N also works)"
    }
    class << self
      def description
        "Students in the district"
      end

      def csv_headers
        [:id_state, :district_student_id, :number, :first_name, :middle_name, :last_name, :suffix, :birthdate,  :esl, :special_ed]
      end

      def overwritten
        "Students with matching district_student_id in the csv file."
      end

      def load_order
        "3.  This should be one of the first files uploaded."
      end

      def removed
        "Students with a district_student_id assignment but not in the file will be removed from the district."
      end

#      def related
#      end

      def how_often
        "Start of each semester, although this is dependent on how often students enter and exit the district.
        If this happens rarely, you may wish to make the changes manually instead."
      end

#      def alternate
#      end

      def upload_responses
        super
      end

      def how_many_rows
        "One row per student."
      end

    end


  private
    def load_data_infile
      headers=csv_headers
      headers[-3]="@birthdate"
      headers[-1]="@special_ed"
      headers[-2]="@esl"
      <<-EOF
          LOAD DATA LOCAL INFILE "#{@clean_file}"
            INTO TABLE #{temporary_table_name}
            FIELDS TERMINATED BY ','
            OPTIONALLY ENCLOSED BY '"'
            (#{headers.join(", ")})
            set birthdate=(ifnull(str_to_date(@birthdate,"%Y-%m-%d"),
            str_to_date(@birthdate,"%m/%d/%Y")) + Interval 0 day
            ),
            special_ed= case trim(lower(@special_ed))
        when 't' then true
        when 'y' then true
        when 'yes' then true
        when 'true' then true
        when '-1' then true
        when '1' then true
        else false
        end,
        esl = case trim(lower(@esl))
        when 'y' then true
        when  't' then true
        when 'yes' then true
        when 'true' then true
        when '-1' then true
        when '1' then true
        when '2' then true
        when '3' then true
        when '4' then true
        when '5' then true
        when '6' then true
        else false
        end ;
        EOF
    end

    def index_options
      [[:id_state, :birthdate, :first_name, :last_name], :district_student_id]
    end


    def sims_model
      Student
    end

    def migration t
      @cols = sims_model.columns_hash
      csv_headers.each do |col|
        c=col.to_s
        t.column col, @cols[c].type, :limit => @cols[c].limit, :null => @cols[c].null
      end
    end

    def temporary_table?
      true
    end

    def postprocess_uploaded_csv
      to_strip=csv_headers.select{|col| @cols[col.to_s].type == :string || @cols[col.to_s].type == :text}

      s= "update #{temporary_table_name} set #{to_strip.collect{|c| "#{c} = trim(#{c})"}.join(', ')}  "




      ActiveRecord::Base.connection.execute(s)
      #"

    end

    def insert_update_delete
      postprocess_uploaded_csv
      #update students s inner join students_546713874_importer ts on ts.id_state = s.id_state set district_id = 546713874 where s.district_id is null and ts.id_state is not null;

      ActiveRecord::Base.connection.execute("update #{temporary_table_name} set id_state = null where id_state = ''")

      try_to_claim_students_in_other_districts
      reject_students_with_nil_data_but_nonmatching_birthdate_or_last_name_if_birthdate_is_nil_on_one_side
      claim_students_with_nil_district
      update_students_already_in_district
      insert
      delete
    end

    #try to claim students in other_districts


    def try_to_claim_students_in_other_districts
      q = "select s.id from  #{temporary_table_name} ts inner join students s on
          ts.id_state = s.id_state
          where s.district_id != #{@district.id} and s.district_id is not null
          and s.id_state is not null and ts.id_state is not null"

      to_claim = ActiveRecord::Base.connection.select_values q
      students = Student.find(to_claim)
      hsh = Hash.new(0)
      students.each do |student|
        res,msg = @district.claim(student)
        hsh[res] +=1
        @messages << msg
      end
      @other_messages << "#{hsh[false]} students could not be claimed, #{hsh[true]} students claimed from other districts.\n"
    end

    def reject_students_with_nil_data_but_nonmatching_birthdate_or_last_name_if_birthdate_is_nil_on_one_side
      shared="#{temporary_table_name} ts inner join students s on
          ts.id_state = s.id_state
          where s.district_id is null
          and s.id_state is not null
          and (
            (ts.birthdate != s.birthdate and ts.birthdate != 0 and s.birthdate != 0 )
             or (
              (s.birthdate = 0 or ts.birthdate = 0 or  ts.birthdate is null or s.birthdate is null )
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


      claimed_count = ActiveRecord::Base.connection.update("update students s inner join #{temporary_table_name} ts on
      ts.id_state = s.id_state and s.district_id is null set s.district_id = #{@district.id}, s.district_student_id = ts.district_student_id")

      claimed_count += ActiveRecord::Base.connection.update("update students s inner join #{temporary_table_name} ts on s.district_id is null and
      ts.id_state is null and s.id_state is null
      set s.district_id = #{@district.id}, s.district_student_id = ts.district_student_id
      where ts.birthdate = s.birthdate and ts.first_name = s.first_name and
                                                               ts.last_name = s.last_name and ts.birthdate is not null    ")
      @other_messages << "#{claimed_count} students claimed that had left another district" if claimed_count > 0


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
      @updated=ActiveRecord::Base.connection.update(q)
    end

    def delete
      #unset the district of  all students that are not in the temporary table
       q="delete e from enrollments e inner join students s on s.id = e.student_id
       left outer join #{temporary_table_name} ts on
          ts.district_student_id = s.district_student_id
          where s.district_id = #{@district.id} and ts.district_student_id is null and s.district_student_id is not null and s.district_student_id != ''"

       clear_enrollments=ActiveRecord::Base.connection.update(q)
       q="update students s left outer join #{temporary_table_name} ts on
          ts.district_student_id = s.district_student_id set s.district_id = null
          where s.district_id = #{@district.id} and ts.district_student_id is null and s.district_student_id is not null and s.district_student_id != ''"

      removed=ActiveRecord::Base.connection.update(q)
      @other_messages << "#{removed} students removed from district; "

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


     @created = ActiveRecord::Base.connection.update(query)
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

