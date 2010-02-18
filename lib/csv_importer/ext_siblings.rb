module CSVImporter
  class ExtSiblings < CSVImporter::Base
  private

    def index_options
      [:district_student_id]
    end

    def csv_headers
      [:district_student_id, :first_name, :middle_name,:last_name, :student_number, :grade, :school_name, :age]
    end

    def sims_model
      ExtArbitrary
    end

    def migration t
      
      t.column :district_student_id, :string
      t.column :first_name, :string
      t.column :middle_name, :string
      t.column :last_name, :string
      t.column :student_number, :string
      t.column :grade, :string
      t.column :school_name, :string
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
       stu.district_student_id is not null
        "
        puts query
      ActiveRecord::Base.connection.execute query
    end

    def insert
      query=("insert into ext_siblings
      (student_id, first_name, middle_name, last_name, student_number, grade, school_name, age, created_at, updated_at)
      select stu.id, te.first_name, te.middle_name, te.last_name, te.student_number, te.grade, te.school_name, te.age, curdate(), curdate() from #{temporary_table_name} te
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

