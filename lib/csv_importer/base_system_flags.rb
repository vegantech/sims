module CSVImporter
  class BaseSystemFlags < CSVImporter::Base
    FIELD_DESCRIPTIONS = {
        district_student_id: "Key for student",
        reason: "A description of the reason the student was flagged.",
    }
    class << self
      def flag_category
        self.file_name.split("_system_flags").first
      end

      def description
        "Student Flags for category #{Flag::FLAGTYPES[flag_category][:humanize]}"
      end

      def csv_headers
        [:district_student_id, :reason]
      end

      def overwritten
        "Students with district_student_id assigned will have their system flags reset."
      end

      def load_order
        "This should be loaded after students, and after the system_flags file if that is used."
      end

      def removed
        "All flags (except ignored or custom) for students with district_student_id assigned will be removed and recreated by this file"
      end

#      def related
#      end

      def how_often
        Flag::FLAGTYPES[flag_category][:how_often_to_upload]
      end

      def alternate
        {system_flags: "You can put all categories together in one file instead.  It's possible to do some categories combined in the system flags file and
          do the rest individually as long as you load the system flags first." }
      end

      def upload_responses
        super
      end

      def how_many_rows
        "One row per flag per student.   Multiple rows of the same flagtype will be combined within SIMS, so each student could have multiple rows in this file."
      end
    end

    def index_options
      [:district_student_id]
    end

    def sims_model
      SystemFlag
    end

    def migration t
      t.column :district_student_id, :string, limit: Student.columns_hash["district_student_id"].limit, null: Student.columns_hash["district_student_id"].null
      t.column :reason, :text
    end

    def temporary_table?
      true
    end

    def delete
      query ="
       delete from sf using flags sf
       inner join students stu on stu.id=sf.student_id and stu.district_id = #{@district.id}
       where
       stu.district_student_id != '' and type= 'SystemFlag' and category = '#{self.class.flag_category}'
        "
      ActiveRecord::Base.connection.update query
    end

    def insert
      query=("insert into flags
      (student_id, category,reason,type, created_at, updated_at)
      select stu.id,'#{self.class.flag_category}',te.reason,'SystemFlag', curdate(), curdate() from #{temporary_table_name} te
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

  Flag::FLAGTYPES.keys.each do |key|
    CSVImporter.const_set("#{key.capitalize}SystemFlags".intern, Class.new(CSVImporter::BaseSystemFlags) do

    end)

  end
end
