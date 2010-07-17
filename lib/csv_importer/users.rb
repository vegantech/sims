module CSVImporter
  class Users < CSVImporter::Base
    FIELD_DESCRIPTIONS = { 
        :district_user_id =>"Key for user",
        :username =>"Used at login",
        :first_name =>"First Name",
        :middle_name =>"Middle Name",
        :last_name =>"Last Name",
        :suffix =>"Suffix",
        :email =>"Email address",
        :passwordhash =>'The encoded password.   Encode the password using the following:  
SHA1.encode("#{system_hash}#{password.downcase}#{district_key}#{salt}")
  replacing the #{} with the appropriate values.  system_hash is currently blank.   
password is the user\'s password in lowercase, district_key is set by the district admin, and the salt is the next field',
        :salt =>"A random value used in the password hash"
    }
    class << self
      def description
        "Users in the district"
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
      [:district_user_id ]
    end

    def csv_headers
      self.class.csv_headers
    end

    def migration t
      t.string :district_user_id
      t.string :username
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :suffix
      t.string :email
      t.string :passwordhash
      t.string :salt

    end

    def update
    updates=csv_headers[0..-3].collect{|e| "u.#{e} = tu.#{e}"}.join(", ")
    query = ("update users u
      inner join #{temporary_table_name} tu
      on u.district_user_id = tu.district_user_id and u.district_user_id is not null
      set u.updated_at=CURDATE(), 
      #{updates}
    where district_id = #{@district.id}"
    )

    User.connection.execute query

    end

    def insert_update_delete
      delete
      update
      insert
      update_passwords
    end

    def delete
      query = "delete  from u
      using users u 
      left outer join #{temporary_table_name} tu 
      on u.district_user_id = tu.district_user_id
      where u.district_user_id is not null and u.district_id = #{@district.id}
      and tu.district_user_id is null"
      User.connection.execute query
    end

    def update_passwords
    updates=csv_headers[-3..-1].collect{|e| "u.#{e} = tu.#{e}"}.join(", ")
    query = ("update users u
      inner join #{temporary_table_name} tu
      on u.district_user_id = tu.district_user_id and u.district_user_id is not null
      set u.updated_at=CURDATE(), 
      #{updates}
    where district_id = #{@district.id} and tu.passwordhash is not null and tu.salt is not null and tu.passwordhash <> '' and tu.salt <> ''"
    )

      User.connection.execute query

    end

    def insert
      inserts = csv_headers.join(", ")
      query=("insert into users 
      (#{inserts}, created_at, updated_at, district_id)
      select tu.* , CURDATE(), CURDATE(), #{@district.id} from #{temporary_table_name} tu left outer join users u  
      on tu.district_user_id = u.district_user_id
      and u.district_id = #{@district.id}  
      where
      u.district_user_id is null
      and tu.district_user_id is not null
      "
      )
      User.connection.execute query
    end


    def confirm_count?
      model_name = "user"
      model_count = @district.send(model_name.tableize).count(:conditions=>'district_user_id is not null and district_user_id !=""')
        if @line_count < (model_count * ImportCSV::DELETE_PERCENT_THRESHOLD  ) && model_count > ImportCSV::DELETE_COUNT_THRESHOLD
          @messages << "Probable bad CSV file.  We are refusing to delete over 40% of your #{model_name.pluralize} records."
          false
        else
          true
        end
    end
                                                                    
  end
end


