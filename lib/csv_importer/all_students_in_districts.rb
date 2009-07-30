module CSVImporter
  class AllStudentsInDistricts < CSVImporter::Base

  private
    def index_options
      [[:personid]]
    end

    def csv_headers
      [:personid]
    end

    def migration t
      t.integer :personID
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
      users u on u.id_district = tug.personID
      and u.district_id = #{@district.id}  
      "
      )
      SpecialUserGroup.connection.execute query
    end
  end
end
