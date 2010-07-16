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
        "What will get overwritten/changed when this file is uploaded."
      end

      def load_order
        "When to upload this file in relation to other files."
      end

      def removed
        "What gets removed when this file is uploaded."
      end

      def related
        "links to related files with explanations."
      end

      def how_often
        "Notes on how often this file should be imported after initial import."
      end

      def alternate
        "links to files that can be used instead of this one, with explanation."
      end

      def upload_responses
        "What you see on the screen or in the email after uploading this file and what the different messages mean. <br />
        In this case you'll see unknown file examples.csv"
      end

    end




  private
    def index_options
      [[:district_user_id]]
    end

    def migration t
      t.string :district_user_id
    end

    def delete
      query = "delete from sug using special_user_groups sug
      inner join users on sug.user_id = users.id
      where users.district_id = #{@district.id}
      and sug.grouptype = #{SpecialUserGroup::ALL_STUDENTS_IN_DISTRICT}
      "
      SpecialUserGroup.connection.execute query
    end

    def insert
      query=("insert into special_user_groups
      (user_id,grouptype,district_id, created_at, updated_at)
      select u.id , #{SpecialUserGroup::ALL_STUDENTS_IN_DISTRICT},#{@district.id}, CURDATE(), CURDATE() from #{temporary_table_name} tug inner join 
      users u on u.district_user_id = tug.district_user_id
      and u.district_id = #{@district.id}  
      "
      )
      SpecialUserGroup.connection.execute query
    end
  end
end
