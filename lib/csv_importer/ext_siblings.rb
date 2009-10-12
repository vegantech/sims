module CSVImporter
  class ExtSiblings < CSVImporter::Base
  private

    def index_options
      [:id_district]
    end

    def csv_headers
      [:id_district, :firstName, :middleName,:lastName, :studentNumber, :grade, :SchoolName, :age]
    end

    def sims_model
      ExtArbitrary
    end

    def migration t
      
      t.column :id_district, :integer
      t.column :firstName, :string
      t.column :middleName, :string
      t.column :lastName, :string
      t.column :studentNumber, :string
      t.column :grade, :string
      t.column :SchoolName, :string
      t.column :age, :integer
      t.column :arbitrary, :text
      
    end

    def temporary_table?
      true
    end

    def delete
      query ="
       delete from ea using  ext_siblings ea
       inner join students stu on stu.id=ea.student_id and stu.district_id = #{@district.id}
       where 
       stu.id_district is not null
        "
        puts query
      ActiveRecord::Base.connection.execute query
    end

    def insert
      query=("insert into ext_siblings
      (student_id, first_name, middle_name, last_name, student_number, grade, school_name, age, created_at, updated_at)
      select stu.id, te.firstName, te.middleName, te.lastName, te.studentNumber, te.grade, te.SchoolName, te.age, curdate(), curdate() from #{temporary_table_name} te
      inner join students stu on stu.id_district = te.id_district
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

