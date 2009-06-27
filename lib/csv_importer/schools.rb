module CSVImporter
  class Schools < CSVImporter::Base

  private
    def index_options
      [:id_district]
    end

    def csv_headers
     [:id_district, :name]
    end

    def sims_model
      School
    end

    def migration t
      t.column :id_district, :integer
      t.column :name, :string
   end


    def update
      query = "update schools s inner join 
      #{temporary_table_name} ts on ts.id_district = s.id_district and s.district_id = #{@district.id}
      and s.id_district is not null
      set s.name=ts.name, s.updated_at=CURDATE()"
      puts query
      ActiveRecord::Base.connection.execute(query)
    end

    def insert_update_delete
      update
      insert
      delete
    end

    def delete
      query = "delete from s
      using schools s
      left outer join #{temporary_table_name} ts
      on s.id_district=ts.id_district
      where s.district_id=#{@district.id} and  s.id_district is not null and ts.id_district is null" 
      ActiveRecord::Base.connection.execute(query)
    end

    def insert
      query=("insert into schools
      (id_district, name, created_at, updated_at, district_id)
      select ts.id_district, ts.name,  CURDATE(), CURDATE(), #{@district.id} from #{temporary_table_name} ts 
      left outer join schools s  
      on ts.id_district = s.id_district
      and s.district_id = #{@district.id} 
      where s.id is null and ts.id_district is not null
      "
      )
      puts query
      Group.connection.execute query
    end
  end
end
