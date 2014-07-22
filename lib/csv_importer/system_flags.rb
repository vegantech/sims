module CSVImporter
  class SystemFlags < CSVImporter::Base
    FIELD_DESCRIPTIONS = { 
        :district_student_id =>"Key for student",
        :category =>"Type of flag, currently one of #{Flag::FLAGTYPES.keys.join(", ")}  It must match one of these exactly, no spaces, all lowercase",
        :reason =>"A description of the reason the student was flagged.",
    }
    class << self
      def description
        "Student Flags"
      end

      def csv_headers
        [:district_student_id, :category, :reason]
      end

      def overwritten
        "Students with district_student_id assigned will have their system flags reset."
      end

      def load_order
        "This should be loaded after students, but before the category specific files"
      end

      def removed
        "All flags (except ignored or custom) for students with district_student_id assigned will be removed and recreated by this file"
      end

#      def related
#      end

      def how_often
        "As soon as possible after availability. 
         (Note - if you are using this data for flags, it needs to be uploaded quickly in order to be used effectively.)"

      end

      def alternate
        h={}
        ImportCSV::VALID_FILES.select{|e| e =~ /_system_flags.csv/}.collect{|e| e.split(".csv").first.to_sym}.each do |f|
          h[f]="Student Flags for category #{Flag::FLAGTYPES[f.to_s.split("_system").first][:humanize]}"
        end
        h
      end

      def how_many_rows
        "One row per flag per student.   Multiple rows of the same flagtype will be combined within SIMS, so each student could have multiple rows in this file."
      end

      def upload_responses
        super
      end

    end

    def index_options
      [:district_student_id, :category]
    end

    def sims_model
      SystemFlag
    end

    def migration t
      
      t.column :district_student_id, :string, :limit =>Student.columns_hash["district_student_id"].limit, :null => Student.columns_hash["district_student_id"].null
      t.column :category,  :string, :limit => Flag.columns_hash["category"].limit, :null => false
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
       stu.district_student_id != '' and type= 'SystemFlag'
        "
      ActiveRecord::Base.connection.update query
    end

    def insert
      query=("insert into flags 
      (student_id, category,reason,type, created_at, updated_at)
      select stu.id,te.category,te.reason,'SystemFlag', curdate(), curdate() from #{temporary_table_name} te
      inner join students stu on stu.district_student_id = te.district_student_id
      where stu.district_id = #{@district.id}
      and  stu.district_student_id != '' 
      and te.category in (#{valid_categories})
      "
      )
      ActiveRecord::Base.connection.update query
    end

   def confirm_count?
     return true
   end

   def valid_categories
     keys=Flag::FLAGTYPES.keys.collect{|e| "'" + e + "'"}.join(",")

   end

   def before_import
     keys=valid_categories
     query ="select * from #{temporary_table_name}
             where category not in (#{keys})"

     res=ActiveRecord::Base.connection.select_rows query
     unless res.blank?
       msg = res.collect{|e| e.join(",")}.join("; ")
       @other_messages << "Unknown Categories for #{msg}"
     end
   end
 

  end
end

