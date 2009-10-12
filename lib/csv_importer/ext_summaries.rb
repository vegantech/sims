module CSVImporter
  class ExtSummaries < CSVImporter::Base
  private

    def index_options
      [:personID]
    end
    
    def csv_headers
    [
    :HomeLanguage, :personID, :streetAddress, :cityStateZip, :mealstatus, :englishProficiency, :specialEdStatus, :disability1, :disability2, :singleParent, :raceEthnicity, :suspensions_in, :suspensions_out, :years_in_district, :school_changes, :years_at_current_school, :previous_school_name, :current_attendance_rate, :previous_attendance_rate, :esl, :tardies
    ]
    end

    def sims_model
      ExtArbitrary
    end

    def migration t

      t.column :HomeLanguage, :string
      t.column :personID, :integer
     t.column :streetAddress, :string
     t.column :cityStateZip, :string
     t.column :mealstatus, :string
     t.column :englishProficiency, :string
     t.column :specialEdStatus, :string
     t.column :disability1, :string
     t.column :disability2, :string
     t.column :singleParent, :boolean
     t.column :raceEthnicity, :string
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
       stu.id_district is not null
        "
        puts query
      ActiveRecord::Base.connection.execute query
    end


    
    def insert
      query=("insert into ext_summaries
      select NULL,stu.id, 
       te.HomeLanguage, te.streetAddress, te.cityStateZip, te.mealstatus, te.englishProficiency, te.specialEdStatus, te.disability1, te.disability2, te.singleParent, te.raceEthnicity, te.suspensions_in, te.suspensions_out, te.years_in_district, te. school_changes, te.years_at_current_school, te.previous_school_name, te.current_attendance_rate, te.previous_attendance_rate, te.esl, te.tardies,
       curdate(), curdate() from #{temporary_table_name} te
      inner join students stu on stu.id_district = te.personID
      where stu.district_id = #{@district.id}
      and  stu.id_district is not null 
      "
      )
        puts query
      ActiveRecord::Base.connection.execute query
    end

   def confirm_count?
     return true
    model_name = sims_model.name
    model_count = Enrollment.count(:joins=>:school,:conditions => ["district_id = ?",@district.id])
    if @line_count < (model_count * ImportCSV::DELETE_PERCENT_THRESHOLD  ) && model_count > ImportCSV::DELETE_COUNT_THRESHOLD
      @messages << "Probable bad CSV file.  We are refusing to delete over 40% of your #{model_name.pluralize} records."
      false
    else
      true
    end
    end
 


  end
end

