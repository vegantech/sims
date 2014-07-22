module CSVImporter
  class AdminsOfSchools < CSVImporter::Base
     FIELD_DESCRIPTIONS = {
      district_user_id: 'Key for user',
      district_school_id: 'Key for school'
    }
    class << self
      def description
        "Assigns administrators to schools.  The file looks just like user_school_assignments.csv, but will assign the users here as the admin of the school."
      end

      def csv_headers
        [:district_user_id, :district_school_id]
      end

      def overwritten
      end

      def load_order
        "This should be done after users and schools.  "
      end

      def removed
      end

      def related
        {user_school_assignments: "Non-admin user school assignments."}
      end

      def how_often
        "Start of each semester (depending on frequency of new staff may need to be
        done more or less often; should be done at same time as the \"users\" file)."
      end

#      def alternate
#        "school_admins.csv"
#      end

      def upload_responses
        super
      end

      def how_many_rows
        "One row per user admin per school.  A school could have multiple admins and a user can be an admin to multiple schools."
      end
    end

    private

    def index_options
      [:district_school_id, :district_user_id]
    end

    def remove_duplicates?
      true
    end

    def migration t
      t.column :district_school_id, :integer
      t.column :district_user_id, :string, limit: User.columns_hash["district_user_id"].limit, null: User.columns_hash["district_user_id"].null
    end

    def delete
      query ="
       delete from usa using  user_school_assignments usa
       inner join schools sch on usa.school_id = sch.id and sch.district_id= #{@district.id}
       inner join users u on usa.user_id = u.id and u.district_id = #{@district.id}
       left outer join #{temporary_table_name} tusa
       on tusa.district_school_id = sch.district_school_id and
       tusa.district_user_id = u.district_user_id
       where sch.district_school_id is not null  and u.district_user_id != ''
       and sch.district_school_id != ''
        and (usa.admin = true) and tusa.district_school_id is null
        "
      ActiveRecord::Base.connection.update query
    end

    def insert
      query=("insert into user_school_assignments
      (school_id, user_id , created_at, updated_at,admin)
      select sch.id, u.id,  curdate(), curdate(), true from #{temporary_table_name} tusa
      inner join schools sch on sch.district_school_id = tusa.district_school_id
      inner join users u on u.district_user_id = tusa.district_user_id
      left outer join user_school_assignments usa on usa.school_id = sch.id and usa.user_id = u.id and usa.admin = true
      where sch.district_id= #{@district.id} and u.district_id = #{@district.id} and usa.id is null
      "
      )
      ActiveRecord::Base.connection.update query
    end
  end
end

