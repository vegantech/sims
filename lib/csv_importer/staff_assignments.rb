module CSVImporter
  class StaffAssignments < CSVImporter::Base
   FIELD_DESCRIPTIONS = { 
      district_user_id: 'Key for user',
      district_school_id: 'Key for school'
    }

    
    class << self
      def description
        "OPTIONAL- used when many users have access to a school but you want to limit the participants and other dropdowns to users that work at that school"
      end

      def csv_headers
        [:district_user_id, :district_school_id]
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
        "If used, once per year, or as often as \"users\" file is uploaded."
      end

#      def alternate
#      end

      def upload_responses
        super
      end

      def how_many_rows
        "One row per user per school.  A school will have multiple users assigned, and a user could be assigned to multiple schools.  (If you are using this file, then you only want to include users with a phsyical presence at that school.)"  
      end
    end

    private

    def index_options
      [:district_user_id, :district_school_id]
    end

    def remove_duplicates?
      true
    end

    def migration t
      t.column :district_user_id, :string, limit: User.columns_hash["district_user_id"].limit, null: User.columns_hash["district_user_id"].null
      t.column :district_school_id, :integer
    end

    def delete
      query ="
       delete from usa using  staff_assignments  usa 
       inner join schools sch on usa.school_id = sch.id and sch.district_id= #{@district.id}
       inner join users u on usa.user_id = u.id
       where sch.district_school_id is not null and u.district_user_id != ''
        "
      ActiveRecord::Base.connection.update query
    end

    def insert
      query=("insert into staff_assignments
      (school_id, user_id)
      select sch.id, u.id from #{temporary_table_name} tusa
      inner join schools sch on sch.district_school_id = tusa.district_school_id
      inner join users u on u.district_user_id = tusa.district_user_id
      where sch.district_id= #{@district.id} and u.district_id = #{@district.id}
      "
      )
      ActiveRecord::Base.connection.update query
    end
   
  end
end

