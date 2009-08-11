module CSVImporter
  class StaffAssignments < CSVImporter::Base
  
    private

    def index_options
      [:personID, :schoolid]
    end

    def csv_headers
      [:personID, :schoolid]
    end

    def migration t
      t.column :personID, :integer
      t.column :schoolid, :integer
    end

    def delete
      query ="
       delete from usa using  staff_assignments  usa 
       inner join schools sch on usa.school_id = sch.id and sch.district_id= #{@district.id}
       where sch.id_district is not null
        "
      ActiveRecord::Base.connection.execute query
    end

    def insert
      query=("insert into staff_assignments
      (school_id, user_id)
      select sch.id, u.id from #{temporary_table_name} tusa
      inner join schools sch on sch.id_district = tusa.schoolid
      inner join users u on u.id_district = tusa.personID
      where sch.district_id= #{@district.id} and u.district_id = #{@district.id}
      "
      )
      ActiveRecord::Base.connection.execute query
    end
   

  end
end

