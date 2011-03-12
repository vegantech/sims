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
      query = "delete from sug using special_user_groups sug
      inner join users on sug.user_id = users.id
      where users.district_id = #{@district.id}
      and sug.grouptype = #{SpecialUserGroup::ALL_STUDENTS_IN_DISTRICT}
      and users.district_user_id != ''
      "
      SpecialUserGroup.connection.delete query
    end

    def insert
      query=("insert into special_user_groups
      (user_id,grouptype,district_id, created_at, updated_at)
      select u.id , #{SpecialUserGroup::ALL_STUDENTS_IN_DISTRICT},#{@district.id}, CURDATE(), CURDATE() from #{temporary_table_name} tug inner join 
      users u on u.district_user_id = tug.district_user_id
      and u.district_id = #{@district.id}  
      "
      )
      SpecialUserGroup.connection.update query
    end
  end
end
