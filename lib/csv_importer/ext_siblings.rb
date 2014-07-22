module CSVImporter
  class ExtSiblings < CSVImporter::Base
    FIELD_DESCRIPTIONS = { 
      :district_student_id =>"Key for student",        
      :first_name =>"First Name",
      :middle_name =>"Middle Name",
      :last_name =>"Last Name",
      :student_number =>"Student number that would appear on report card or student id card.",
      :grade =>"Grade",
      :school_name =>"Currently Enrolled at School",
      :age =>"Age"
    }
    class << self
      def description
        "Brothers and sisters- appears in extended profile"
      end

      def csv_headers
        [:district_student_id, :first_name, :middle_name,:last_name, :student_number, :grade, :school_name, :age]
      end

      def overwritten
      end

      def load_order
      end

      def removed
      end

#      def related
#      end

      def how_often
        "Start of the school year.
        (Note this is a part of the extended profile and not required for functionality of SIMS, so it can be done infrequently.)"
      end

      def how_many_rows
        "One row per sibling, if the person is a sibling to multiple students then they will appear in this file multiple times with different district_student_id."
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
      
      t.column :district_student_id, :string, :limit =>Student.columns_hash["district_student_id"].limit, :null => Student.columns_hash["district_student_id"].null
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
       stu.district_student_id != '' 
        "
      ActiveRecord::Base.connection.update query
    end

    def insert
      query=("insert into ext_siblings
      (student_id, first_name, middle_name, last_name, student_number, grade, school_name, age, created_at, updated_at)
      select stu.id, te.first_name, te.middle_name, te.last_name, te.student_number, te.grade, te.school_name, te.age, curdate(), curdate() from #{temporary_table_name} te
      inner join students stu on stu.district_student_id = te.district_student_id
      where stu.district_id = #{@district.id}
      and  stu.district_student_id != '' 
      "
      )
      ActiveRecord::Base.connection.update query
    end

   def confirm_count?
     return true
   end
 
  end
end

