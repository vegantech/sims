module CSVImporter
  class UserGroups < CSVImporter::Base
    #125.01763010025 seconds!
    #135 with district constrained delete

  private
    def index_options
      [[:district_user_id, :district_group_id]]
    end

    def csv_headers
      [:district_user_id, :district_group_id, :principal]
    end

    def migration t
      t.string :district_user_id
      t.string :district_group_id
      t.boolean :principal
    end

    def delete
      query = "delete from uga using user_group_assignments uga
      inner join users on uga.user_id = users.id
      inner join groups on uga.group_id = groups.id
      inner join schools on groups.school_id = schools.id
      where schools.district_id = #{@district.id} and users.district_id = #{@district.id} and groups.district_group_id is not null
      "

extra ="      where not exists (
        select 1 from #{temporary_table_name} tug
        where tug.district_user_id = users.district_user_id and tug.district_group_id = groups.district_group_id)
      )"
      UserGroupAssignment.connection.execute query
    end

    def insert
      query=("insert into user_group_assignments
      (user_id,group_id, is_principal, created_at, updated_at)
      select u.id , g.id, principal, CURDATE(), CURDATE() from #{temporary_table_name} tug inner join 
      users u on u.district_user_id = tug.district_user_id
      inner join groups g
      on tug.district_group_id = g.district_group_id
      and u.district_id = #{@district.id}  
      "
      )
      Group.connection.execute query
    end
  end
end
