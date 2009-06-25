module CSVImporter
  class UserGroups < CSVImporter::Base
    #125.01763010025 seconds!

  private
    def index_options
      [[:district_user_id, :district_group_id]]
    end

    def csv_headers
      [:district_user_id, :district_group_id]
    end

    def migration t
      t.integer :district_user_id
      t.string :district_group_id
    end

    def delete
      puts 'Fix DELETE, you do not actually want to delete everyone!!!'
      UserGroupAssignment.delete_all
    end

    def insert
      query=("insert into user_group_assignments
      (user_id,group_id, created_at, updated_at)
      select u.id , g.id, CURDATE(), CURDATE() from csv_importer tug inner join 
      users u on u.id_district = tug.district_user_id
      inner join groups g
      on tug.district_group_id = g.id_district
      and u.district_id = #{@district.id}  
      "
      )
      Group.connection.execute query
    end
  end
end
