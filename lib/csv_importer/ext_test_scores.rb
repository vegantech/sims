module CSVImporter
  class ExtTestScores < CSVImporter::Base
  private

    def index_options
      [:district_student_id]
    end
    
    def csv_headers
      [:district_student_id, :name, :date, :scale_score, :result, :end_date]
    end

    def sims_model
      ExtArbitrary
    end

    def migration t
      
      t.column :district_student_id, :string
      t.column :name, :string
      t.column :date, :date
      t.column :scale_score, :float
      t.column :result, :string
      t.column :end_date, :date
   end

    def temporary_table?
      true
    end

    def delete
      query ="
       delete from ea using  ext_test_scores ea
       inner join students stu on stu.id=ea.student_id and stu.district_id = #{@district.id}
       where 
       stu.district_student_id is not null
        "
        puts query
      ActiveRecord::Base.connection.execute query
    end

    def insert
      query=("insert into ext_test_scores
      (student_id, name, date, scaleScore, result, enddate, created_at, updated_at)
      select stu.id, 
      te.name, te.date, te.scale_score, te.result, te.end_date, 
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

