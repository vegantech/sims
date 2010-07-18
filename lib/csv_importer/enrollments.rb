module CSVImporter
  class Enrollments < CSVImporter::Base
    FIELD_DESCRIPTIONS = { 
      :grade =>"Grade of student, whatever is here will be displayed on the screen.",
      :district_school_id =>"Key for school",
      :district_student_id =>"Key for student",
      :end_year =>"Calendar year when school year ends.  the 2010-2011 school year would be 2011"
    }
    class << self
      def description
        "Assigns students to schools"
      end
      def csv_headers
        [:grade, :district_school_id, :district_student_id, :end_year]
      end

      def overwritten
        "What will get overwritten/changed when this file is uploaded."
      end

      def load_order
        "4. This can be uploaded after schools and students."
      end

      def removed
        "Enrollments for students with district_student_id assignment but not in this file."
      end

      def related
      end

      def how_often
        "This should be uploaded whenever students is uploaded."
      end

      def alternate
      end

      def upload_responses
        super
      end

    end


    #12 seconds to preprocess the file and setup the temporary table
    # @real=638.522989988327 with the delete outer join
    #16.5350589752197 with the not exists call
    private

    def index_options
      [[:district_school_id, :district_student_id],[:end_year,:grade]]
    end

    def sims_model
      Enrollment
    end

    def migration t
      cols = sims_model.columns.inject({}){|hash, col| hash[col.name.to_sym] = col.type; hash}

      csv_headers.each do |col|
        t.column col, cols[col] || :string
      end
    end

    def temporary_table?
      true
    end

    def delete
      query ="
       delete from e using  enrollments e 
       inner join schools sch on e.school_id = sch.id and sch.district_id= #{@district.id}
       inner join students stu on stu.id=e.student_id and stu.district_id = #{@district.id}
       where not exists 
        ( select 1 from #{temporary_table_name} te 
          where te.district_school_id = sch.district_school_id and te.district_student_id = stu.district_student_id 
          and te.end_year = e.end_year  and te.grade = e.grade 
        )
        and sch.district_school_id is not null and stu.district_student_id is not null
       "
       puts query
       ActiveRecord::Base.connection.execute query
    end

    def insert
      query=("insert into enrollments
      (school_id, student_id, grade, end_year , created_at, updated_at)
      select sch.id, stu.id, te.grade, te.end_year, curdate(), curdate() from #{temporary_table_name} te
      inner join schools sch on sch.district_school_id = te.district_school_id
      inner join students stu on stu.district_student_id = te.district_student_id
      left outer join enrollments e
      on sch.id = e.school_id and stu.id = e.student_id and te.grade = e.grade and te.end_year = e.end_year
      where sch.district_id= #{@district.id} and stu.district_id = #{@district.id}
      and e.school_id is null and stu.district_student_id is not null and sch.district_school_id is not null
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

