module CSVImporter
  class AllSchools < CSVImporter::Base

  private
    def index_options
      [[:district_user_id]]
    end

    def csv_headers
      [:district_user_id]
    end

    def migration t
      t.string :district_user_id
    end

    def delete
      query = "delete from sug using special_user_groups sug
      inner join users on sug.user_id = users.id
      where users.district_id = #{@district.id}
      and sug.grouptype = #{SpecialUserGroup::ALL_SCHOOLS_IN_DISTRICT}
      "
      SpecialUserGroup.connection.execute query
    end

    def insert
      query=("insert into special_user_groups
      (user_id,grouptype,district_id, created_at, updated_at)
      select u.id , #{SpecialUserGroup::ALL_SCHOOLS_IN_DISTRICT},#{@district.id}, CURDATE(), CURDATE() from #{temporary_table_name} tug inner join 
      users u on u.district_user_id = tug.district_user_id
      and u.district_id = #{@district.id}  
      "
      )
      SpecialUserGroup.connection.execute query
    end
  end
end
