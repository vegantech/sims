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

    def delete
      Group.delete_all
    end

    def insert
      inserts = csv_headers.join(", ")
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
