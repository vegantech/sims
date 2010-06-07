module CSVImporter
  class ExtAdultContacts < CSVImporter::Base
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
    
    def csv_headers
      [:district_student_id, :relationship, :guardian, :first_name,:last_name, :home_phone, :work_phone, :cell_phone, :pager, :email, :street_address, :city_state_zip]
    end

    def sims_model
      ExtArbitrary
    end

    def migration t
      
      t.column :district_student_id, :string
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
       stu.district_student_id is not null
        "
        puts query
      ActiveRecord::Base.connection.execute query
    end

    def insert
      query=("insert into ext_adult_contacts
      (student_id, relationship, guardian, firstName, lastName, homePhone, workPhone, cellPhone, pager, email, streetAddress, cityStateZip, created_at, updated_at)
      select stu.id, 
       te.relationship, te.guardian, te.first_name, te.last_name, te.home_phone, te.work_phone, te.cell_phone, te.pager, te.email, te.street_address, te.city_state_zip, 
       curdate(), curdate() from #{temporary_table_name} te
      inner join students stu on stu.district_student_id = te.district_student_id
      where stu.district_id = #{@district.id}
      and  stu.district_student_id is not null 
      "
      )
        puts query
      ActiveRecord::Base.connection.execute query
    end
   def confirm_count?
     return true
   end
 


  end
end

