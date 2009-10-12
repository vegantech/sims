module CSVImporter
  class ExtArbitraries < CSVImporter::Base
  private

    def index_options
      [:id_district]
    end

    def csv_headers
      [:id_district, :arbitrary]
    end

    def sims_model
      ExtArbitrary
    end

    def migration t
      
      t.column :id_district, :integer
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
       stu.id_district is not null
        "
        puts query
      ActiveRecord::Base.connection.execute query
    end

    def insert
      query=("insert into ext_arbitraries
      (student_id, content, created_at, updated_at)
      select stu.id, te.arbitrary, curdate(), curdate() from #{temporary_table_name} te
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

