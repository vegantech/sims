module CSVImporter
  class Users < CSVImporter::Base
    FIELD_DESCRIPTIONS = { 
        district_user_id: "Key for user (30 char limit)",
        username: "Used at login (30 char limit)",
        first_name: "First Name",
        middle_name: "Middle Name",
        last_name: "Last Name",
        suffix: "Suffix",
        email: "Email address (must be valid)",
        passwordhash: 'The encoded password.   Encode the password using the following:  
SHA1.encode("#{system_hash}#{password.downcase}#{district_key}#{salt}")
  replacing the #{} with the appropriate values.  system_hash is currently blank.   
password is the user\'s password in lowercase, district_key is set by the district admin, and the salt is the next field',
        salt: "A random value used in the password hash"
    }
    class << self
      def description
        "Users in the district.  Note you can leave the password and salt blank, if so then be sure to set a district_key and make sure the email is present.
        The district key acts as an initial password, which users will change when they first login."
      end

      def csv_headers
        [:district_user_id, :username, :first_name, :middle_name, :last_name, :suffix, :email, :passwordhash, :salt]
      end

      def optional_headers
        [:passwordhash, :salt]
      end

      def overwritten
        "Users with matching district_user_id in the file will be overwritten."
      end

      def load_order
        "2. This should be uploaded before most other files."
      end

      def removed
        "Users with district_user_id assigned but not in the file are removed from the district."
      end

#      def related
#      end

      def how_often
        "Start of each semester (depending on frequency of new staff may need to be done more or less often)."
      end

      def how_many_rows
        "One row per user."
      end

#      def alternate
#      end

      def upload_responses
        super
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
      @cols = User.columns_hash
      csv_headers.each do |col|
        c=col.to_s
        t.column col, @cols[c].type, limit: @cols[c].limit, null: @cols[c].null
      end
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

    User.connection.update query
    end

    def insert_update_delete
      @deleted=delete
      @updated=update
      @created=insert
      @other_messages << "#{update_passwords} passwords updated"
    end

    def delete
     query = "select id from users u left outer join #{temporary_table_name} tu
        on u.district_user_id = tu.district_user_id
        where u.district_user_id !='' and u.district_id = #{@district.id}
        and tu.district_user_id is null"
      user_ids_to_remove=User.connection.select_rows(query)
      User.remove_from_district(user_ids_to_remove)
      user_ids_to_remove.length
    end

    def update_passwords
    updates=csv_headers[-3..-1].collect{|e| "u.#{e} = tu.#{e}"}.join(", ")
    query = ("update users u
      inner join #{temporary_table_name} tu
      on u.district_user_id = tu.district_user_id and u.district_user_id !=''
      set u.updated_at=CURDATE(), 
      #{updates}
    where district_id = #{@district.id} and tu.passwordhash is not null and tu.salt is not null and tu.passwordhash <> '' and tu.salt <> ''"
    )

      User.connection.update query
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
      User.connection.update query
    end

    def confirm_count?
      model_name = "user"
      model_count = @district.send(model_name.tableize).count(conditions: 'district_user_id is not null and district_user_id !=""')
        if @line_count < (model_count * ImportCSV::DELETE_PERCENT_THRESHOLD  ) && model_count > ImportCSV::DELETE_COUNT_THRESHOLD
          @messages << "Probable bad CSV file.  We are refusing to delete over 40% of your #{model_name.pluralize} records."
          false
        else
          true
        end
    end
  end
end


