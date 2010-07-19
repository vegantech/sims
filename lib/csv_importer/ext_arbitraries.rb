module CSVImporter
  class ExtArbitraries < CSVImporter::Base
    FIELD_DESCRIPTIONS = { 
        :district_student_id =>"Key for student",
        :arbitrary =>"Custom HTML content to appear in the extended profile.  I recommend putting everything in a div tag."      
    }
    class << self
      def description
        "Freeform html that appears at the end of the extended profile"
      end

      def csv_headers
        [:district_student_id, :arbitrary]
      end

      def overwritten
        "What will get overwritten/changed when this file is uploaded."
      end

      def load_order
        "This can be uploaded after students."
      end

      def removed
      end

#      def related
#      end

      def how_often
        "Once per year if you choose to use it, otherwise never."
      end

#      def alternate
#      end

      def upload_responses
        super
      end

    end

  private

    def index_options
      [:district_student_id]
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

