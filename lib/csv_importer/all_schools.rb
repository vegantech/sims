module CSVImporter
  class AllSchools < CSVImporter::Base

    FIELD_DESCRIPTIONS = {
      :district_user_id => 'Key for user'
    }

    class << self

      def description
        "List of users with access to all schools in the district. Be sure to also give them regular user access and to assign them to groups."
      end

      def csv_headers
        [:district_user_id]
      end

      def overwritten
      end

      def load_order
        "This should be done after users."
      end

      def removed
      end

#      def related
#      end

#      def alternate
#      end

      def how_often
        "Start of each semester (depending on frequency of new staff may need to be done more or less often; should be done at same time as the \"users\" file)."
      end

      def how_many_rows
        "One row per user with this access."
      end

      def upload_responses
        super
      end

    end

    private
    def index_options
      [[:district_user_id]]
    end

    def remove_duplicates?
      true
    end

    def migration t
      t.string :district_user_id, :limit => User.columns_hash["district_user_id"].limit, :null => User.columns_hash["district_user_id"].null
    end

    def delete
      query = "update users u
               left outer join #{temporary_table_name} t_r on t_r.district_user_id = u.district_user_id
               set all_schools = false,
               u.updated_at = CURDATE()
               where t_r.district_user_id is null and u.district_user_id != '' and u.all_schools = 1
               and u.district_id = #{@district.id}
               "
      User.connection.update query
    end

    def insert
      query = "update users u
               inner join #{temporary_table_name} t_r on t_r.district_user_id = u.district_user_id
               set all_schools = true,
               u.updated_at = CURDATE()
               where u.district_user_id != '' and u.all_schools = 0
               and u.district_id = #{@district.id}
               "
      User.connection.update query
    end
  end
end
