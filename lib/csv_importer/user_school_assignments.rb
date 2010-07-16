module CSVImporter
  class UserSchoolAssignments < CSVImporter::Base
     FIELD_DESCRIPTIONS = { 
      :district_example_id => 'the primary key used in the student information system by the district',
      :example_text => 'some other field'
    }
    class << self
      def description
        "Assigns users to schools. This provides access in the school selection screen"
      end

      def csv_headers
        [:district_user_id, :username, :first_name, :middle_name, :last_name, :suffix, :email, :passwordhash, :salt]
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
      [:district_school_id, :district_user_id]
    end

    def csv_headers
      [:district_user_id, :district_school_id]
    end

    def migration t
      t.column :district_school_id, :integer
      t.column :district_user_id, :string
    end

    def delete
      query ="
       delete from usa using  user_school_assignments usa 
       inner join schools sch on usa.school_id = sch.id and sch.district_id= #{@district.id}
       where sch.district_school_id is not null
        and (usa.admin = false or usa.admin is null)
        "
        puts query
      ActiveRecord::Base.connection.execute query
    end

    def insert
      query=("insert into user_school_assignments
      (school_id, user_id , created_at, updated_at)
      select sch.id, u.id,  curdate(), curdate() from #{temporary_table_name} tusa
      inner join schools sch on sch.district_school_id = tusa.district_school_id
      inner join users u on u.district_user_id = tusa.district_user_id
      where sch.district_id= #{@district.id} and u.district_id = #{@district.id}
      "
      )
        puts query
      ActiveRecord::Base.connection.execute query
    end
   

  end
end

