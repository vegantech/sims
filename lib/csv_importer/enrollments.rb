module CSVImporter
  class Enrollments < CSVImporter::Base
    #12 seconds to preprocess the file and setup the temporary table
    # @real=638.522989988327 with the delete outer join
    #16.5350589752197 with the not exists call
  private

    def index_options
      [[:school_id_district, :student_id_district],[:end_year,:grade]]
    end

    def csv_headers
      [:grade, :school_id_district, :student_id_district, :end_year]
    end

    def sims_model
      Enrollment
    end

    def migration t
      cols = sims_model.columns.inject({}){|hash, col| hash[col.name.to_sym] = col.type; hash}

      csv_headers.each do |col|
        t.column col, cols[col] || :integer
      end
    end

    def delete
      query ="
       delete from e using  enrollments e 
       inner join schools sch on e.school_id = sch.id and sch.district_id= #{@district.id}
       inner join students stu on stu.id=e.student_id and stu.district_id = #{@district.id}
       where not exists 
        ( select 1 from #{temporary_table_name} te 
          where te.school_id_district = sch.id_district and te.student_id_district = stu.id_district 
          and te.end_year = e.end_year  and te.grade = e.grade 
        )
        and sch.id_district is not null and stu.id_district is not null
        "
      ActiveRecord::Base.connection.execute query
    end

    def insert
      query=("insert into enrollments
      (school_id, student_id, grade, end_year , created_at, updated_at)
      select sch.id, stu.id, te.grade, te.end_year, curdate(), curdate() from #{temporary_table_name} te
      inner join schools sch on sch.id_district = te.school_id_district
      inner join students stu on stu.id_district = te.student_id_district
      left outer join enrollments e
      on sch.id = e.school_id and stu.id = e.student_id and te.grade = e.grade and te.end_year = e.end_year
      where sch.district_id= #{@district.id} and stu.district_id = #{@district.id}
      and e.school_id is null and stu.id_district is not null and sch.id_district is not null
      "
      )
      ActiveRecord::Base.connection.execute query
    end
   def confirm_count?
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

