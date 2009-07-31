module CSVImporter
  class UserSchoolAssignments < CSVImporter::Base
  
    private

    def index_options
      [:district_school_id, :personID]
    end

    def csv_headers
      [:personID, :district_school_id]
    end

    def migration t
      t.column :district_school_id, :integer
      t.column :personID, :integer
    end

    def delete
      query ="
       delete from usa using  user_school_assignments usa 
       inner join schools sch on usa.school_id = sch.id and sch.district_id= #{@district.id}
       where sch.id_district is not null
        and (usa.admin = false or usa.admin is null)
        "
        puts query
      ActiveRecord::Base.connection.execute query
    end

    def insert
      query=("insert into user_school_assignments
      (school_id, user_id , created_at, updated_at)
      select sch.id, u.id,  curdate(), curdate() from #{temporary_table_name} tusa
      inner join schools sch on sch.id_district = tusa.district_school_id
      inner join users u on u.id_district = tusa.personID
      where sch.district_id= #{@district.id} and u.district_id = #{@district.id}
      "
      )
        puts query
      ActiveRecord::Base.connection.execute query
    end
   

  end
end

