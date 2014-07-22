module CSVImporter
  class UserSchoolAssignments < CSVImporter::Base
     FIELD_DESCRIPTIONS = {
      :district_user_id => 'Key for user',
      :district_school_id => 'Key for school'
    }
    class << self
      def description
        "Assigns users to schools. This provides access in the school selection screen."
      end

      def csv_headers
        [:district_user_id, :district_school_id]
      end

      def overwritten
      end

      def load_order
        "This should be done before all_students_in_schools.csv and after users and schools.  "
      end

      def removed
        "User school assignments where the district_school_id and district_user_id are provided will be removed if not in this file.   Note admin assignments will not be removed"
      end

      def related
        {:admins_of_schools => "School Administrators are assigned here."}
      end

      def how_often
        "Start of each semester (depending on frequency of new staff may need to be
        done more or less often; should be done at same time as the \"users\" file)."
      end

#      def alternate
#      end

      def upload_responses
        super
      end

      def how_many_rows
        "One row per user per school.  A school will have multiple users and a user can belong to multiple schools."
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
      t.column :district_user_id, :string, :limit => User.columns_hash["district_user_id"].limit, :null => User.columns_hash["district_user_id"].null
    end

    def delete
      query ="
       delete from usa using  user_school_assignments usa
       inner join schools sch on usa.school_id = sch.id and sch.district_id= #{@district.id}
       inner join users u on usa.user_id = u.id
       left outer join #{temporary_table_name} tusa
       on tusa.district_school_id = sch.district_school_id and
       tusa.district_user_id = u.district_user_id
       where sch.district_school_id is not null  and u.district_user_id != ''
        and (usa.admin = false or usa.admin is null) and tusa.district_school_id is null
        "
      ActiveRecord::Base.connection.update query
    end

    def insert
      query=("insert into user_school_assignments
      (school_id, user_id , created_at, updated_at)
      select sch.id, u.id,  curdate(), curdate() from #{temporary_table_name} tusa
      inner join schools sch on sch.district_school_id = tusa.district_school_id
      inner join users u on u.district_user_id = tusa.district_user_id
      left outer join user_school_assignments usa on usa.school_id = sch.id and usa.user_id = u.id
      where sch.district_id= #{@district.id} and u.district_id = #{@district.id} and usa.id is null
      "
      )
      ActiveRecord::Base.connection.update query
    end
  end
end

