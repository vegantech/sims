module CSVImporter
  class AllStudentsInDistricts < CSVImporter::Base
    FIELD_DESCRIPTIONS = {
      :district_user_id => 'Key for user'
    }

    class << self
      def file_name
        "all_students_in_district.csv"
      end

      def description
        "List of users with access to all students in the district. Be sure to also give them regular user access."
      end

      def csv_headers
        [:district_user_id]
      end

      def overwritten
        "Users in this file will be given access to all students in the district."
      end

      def load_order
        "6. Initially, it is easiest to give all users this level of access.  Then you can move on to more limited access (by school, then by group) as you work on other files."
      end

      def removed
        "Users not in this file but with a district_user_id assigned will have access to all students_in_district removed."
      end

#      def related
#      end

      def how_often
        "If used, it should be updated as often as users.  Once you are using other levels of access, you might want prefer to manage this manually."
      end

      def how_many_rows
        "One row per user with this access."
      end

#      def alternate
#      end

      def upload_responses
        super
      end
    end

    private
    def index_options
      [[:district_user_id]]
    end

    def migration t
      t.string :district_user_id, :limit => User.columns_hash["district_user_id"].limit, :null => User.columns_hash["district_user_id"].null
    end

    def remove_duplicates?
      true
    end

    def delete
      query = "update users u
               left outer join #{temporary_table_name} t_r on t_r.district_user_id = u.district_user_id
               set all_students = false,
               u.updated_at = CURDATE()
               where t_r.district_user_id is null and u.district_user_id != '' and u.all_students = 1
               and u.district_id = #{@district.id}
               "
      User.connection.update query
    end

    def insert
      query = "update users u
               inner join #{temporary_table_name} t_r on t_r.district_user_id = u.district_user_id
               set all_students = true,
               u.updated_at = CURDATE()
               where u.district_user_id != '' and u.all_students = 0
               and u.district_id = #{@district.id}
               "
      User.connection.update query
    end
  end
end
