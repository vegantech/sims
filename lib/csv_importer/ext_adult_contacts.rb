module CSVImporter
  class ExtAdultContacts < CSVImporter::Base
    FIELD_DESCRIPTIONS = { 
        district_student_id: "Key for student",
        relationship: "String describing relationship.  Something like Parent or Emergency Contact",
        guardian: "true if contact is a parent/guardian and entitled to records,   blank otherwise (Y/N also works)",
        first_name: "First Name",
        last_name: "Last Name",
        home_phone: "Home Phone #",
        work_phone: "Work Phone #",
        cell_phone: "Cell Phone #",
        pager: "Pager #",
        email: "Email Address",
        street_address: "First line of address",
        city_state_zip: "City, State, Zip"
    }
    class << self
      def description
        "Parents, guardians and other emergency contacts- appears in extended profile"
      end

      def csv_headers
        [:district_student_id, :relationship, :guardian, :first_name,:last_name, :home_phone, :work_phone, :cell_phone, :pager, :email, :street_address, :city_state_zip]
      end

      def overwritten
      end

      def load_order
        "This can be done after students."
      end

      def removed
      end

#      def related
#      end

      def how_often
        "Start of the school year. (Note this is a part of the extended profile and not required for functionality of SIMS, so it can be done infrequently.)"
      end

      def how_many_rows
        "One row per contact.  There can be multiple contacts per student.  If the same person is a contact for another student, then there will be another row for that contact (with a different district_student_id.)"
      end

#      def alternate
#      end

      def upload_responses
        super
      end
    end

    private
    def load_data_infile
      headers=csv_headers
      headers[2]="@guardian"
      <<-EOF
          LOAD DATA LOCAL INFILE "#{@clean_file}" 
            INTO TABLE #{temporary_table_name}
            FIELDS TERMINATED BY ','
            OPTIONALLY ENCLOSED BY '"'
            (#{headers.join(", ")})
            set guardian= case trim(lower(@guardian)) 
        when 't' then true 
        when 'y' then true 
        when 'yes' then true 
        when 'true' then true 
        when '-1' then true 
        when '1' then true 
        else false 
        end ;
        EOF
    end
 

    def index_options
      [:district_student_id]
    end
    

    def sims_model
      ExtArbitrary
    end

    def migration t
      
      t.column :district_student_id, :string, limit: Student.columns_hash["district_student_id"].limit, null: Student.columns_hash["district_student_id"].null
      t.column :guardian, :boolean
      t.column :relationship, :string
      t.column :first_name, :string
      t.column :last_name, :string
      t.column :home_phone, :string
      t.column :work_phone, :string
      t.column :cell_phone, :string
      t.column :pager, :string
      t.column :email, :string
      t.column :street_address, :string
      t.column :city_state_zip, :string
    end

    def temporary_table?
      true
    end

    def delete
      query ="
       delete from ea using  ext_adult_contacts ea
       inner join students stu on stu.id=ea.student_id and stu.district_id = #{@district.id}
       where 
       stu.district_student_id != ''
        "
      ActiveRecord::Base.connection.update query
    end

    def insert
      query=("insert into ext_adult_contacts
      (student_id, relationship, guardian, firstName, lastName, homePhone, workPhone, cellPhone, pager, email, streetAddress, cityStateZip, created_at, updated_at)
      select stu.id, 
       te.relationship, te.guardian, te.first_name, te.last_name, te.home_phone, te.work_phone, te.cell_phone, te.pager, te.email, te.street_address, te.city_state_zip, 
       curdate(), curdate() from #{temporary_table_name} te
      inner join students stu on stu.district_student_id = te.district_student_id
      where stu.district_id = #{@district.id}
      and  stu.district_student_id != ''
      "
      )
      ActiveRecord::Base.connection.update query
    end

   def confirm_count?
     return true
   end
 
  end
end

