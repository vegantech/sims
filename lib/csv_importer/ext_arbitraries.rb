module CSVImporter
  class ExtArbitraries < CSVImporter::Base
  private

    def index_options
      [:district_student_id]
    end

    def csv_headers
      [:district_student_id, :arbitrary]
    end

    def sims_model
      ExtArbitrary
    end

    def migration t
      
      t.column :district_student_id, :string
      t.column :arbitrary, :text
      
    end

    def temporary_table?
      true
    end

    def delete
      query ="
       delete from ea using  ext_arbitraries ea
       inner join students stu on stu.id=ea.student_id and stu.district_id = #{@district.id}
       where 
       stu.district_student_id is not null
        "
        puts query
      ActiveRecord::Base.connection.execute query
    end

    def insert
      query=("insert into ext_arbitraries
      (student_id, content, created_at, updated_at)
      select stu.id, te.arbitrary, curdate(), curdate() from #{temporary_table_name} te
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

