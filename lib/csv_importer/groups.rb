module CSVImporter
  class Groups < CSVImporter::Base

  private
    def index_options
      [:district_school_id ]
    end

    def csv_headers
     [:district_group_id, :district_school_id, :name]
    end

    def migration t
      t.string :district_group_id
      t.string :district_school_id
      t.string :name
    end

    def update


    end

    def insert_update_delete
      delete
      update
      insert
    end

    def delete
      puts 'FIX DELETE, you do not actually want to delete everyone'
      Group.delete_all
    end

    def insert
      query=("insert into groups
      (title,school_id,id_district, created_at, updated_at)
      select tg.name , s.id, tg.district_group_id , CURDATE(), CURDATE() from csv_importer tg inner join schools s  
      on tg.district_school_id = s.id_district
      and s.district_id = #{@district.id}  
      "
      )
      Group.connection.execute query
    end
  end
end
