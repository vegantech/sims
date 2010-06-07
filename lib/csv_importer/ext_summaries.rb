module CSVImporter
  class ExtSummaries < CSVImporter::Base
  private


    def load_data_infile
      headers=csv_headers
      headers[-2]="@esl"
      headers[-2]="@single_parent"
      <<-EOF
          LOAD DATA LOCAL INFILE "#{@clean_file}" 
            INTO TABLE #{temporary_table_name}
            FIELDS TERMINATED BY ','
            OPTIONALLY ENCLOSED BY '"'
            (#{headers.join(", ")})
        set     esl= case trim(lower(@esl)) 
        when 't' then true 
        when 'y' then true 
        when 'yes' then true 
        when 'true' then true 
        when '-1' then true 
        when '1' then true 
        else false 
        end ,
        single_parent= case trim(lower(@single_parent)) 
        when 't' then true 
        when 'y' then true 
        when 'yes' then true 
        when 'true' then true 
        when '-1' then true 
        when '1' then true 
        else false 
        end ;

        EOF
    end
 

    def index_options
      [:district_student_id]
    end
    
    def csv_headers
    [
    :district_student_id,:home_language, :street_address, :city_state_zip, :meal_status, :english_proficiency, :special_ed_status, :disability1, :disability2, :single_parent, :race_ethnicity, :suspensions_in, :suspensions_out, :years_in_district, :school_changes, :years_at_current_school, :previous_school_name, :current_attendance_rate, :previous_attendance_rate, :esl, :tardies
    ]
    end

    def sims_model
      ExtArbitrary
    end

    def migration t

      t.column :district_student_id, :string
      t.column :home_language, :string
     t.column :street_address, :string
     t.column :city_state_zip, :string
     t.column :meal_status, :string
     t.column :english_proficiency, :string
     t.column :special_ed_status, :string
     t.column :disability1, :string
     t.column :disability2, :string
     t.column :single_parent, :boolean
     t.column :race_ethnicity, :string
     t.column :suspensions_in, :integer
     t.column :suspensions_out, :integer
     t.column :years_in_district, :integer
     t.column :school_changes, :integer
     t.column :years_at_current_school, :integer
     t.column :previous_school_name, :string
     t.column :current_attendance_rate, :float
     t.column :previous_attendance_rate, :float
     t.column :esl, :boolean
     t.column :tardies, :integer
     
  end

    def temporary_table?
      true
    end

    def delete
      query ="
       delete from ea using  ext_summaries ea
       inner join students stu on stu.id=ea.student_id and stu.district_id = #{@district.id}
       where 
       stu.district_student_id is not null
        "
        puts query
      ActiveRecord::Base.connection.execute query
    end


    
    def insert
      query=("insert into ext_summaries
      select NULL,stu.id, 
       te.home_language, te.street_address, te.city_state_zip, te.meal_status, te.english_proficiency, te.special_ed_status, te.disability1, te.disability2, te.single_parent, te.race_ethnicity, te.suspensions_in, te.suspensions_out, te.years_in_district, te. school_changes, te.years_at_current_school, te.previous_school_name, te.current_attendance_rate, te.previous_attendance_rate, te.esl, te.tardies,
       curdate(), curdate() from #{temporary_table_name} te
      inner join students stu on stu.district_student_id = te.district_student_id
      where stu.district_id = #{@district.id}
      and  stu.district_student_id is not null 
      "
      )
        puts query
      ActiveRecord::Base.connection.execute query
    end

   def confirm_count?
     return true
    end
 


  end
end

