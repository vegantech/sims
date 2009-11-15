module CSVImporter
  class Groups < CSVImporter::Base
    #    77.6728281974792

  private
    def index_options
      [[:district_group_id, :district_school_id] ]
    end

    def csv_headers
     [:district_group_id, :district_school_id, :name]
    end
    

    def migration t
      t.string :district_group_id
      t.string :district_school_id
      t.string :name
    end

    def sims_model
      Group
    end

    def update
      query=("update groups
        inner join  #{temporary_table_name} tg on tg.district_group_id = groups.district_group_id
        inner join schools sch on sch.district_school_id = tg.district_school_id
        set groups.school_id = sch.id, groups.district_group_id = tg.district_group_id, groups.title = tg.name,  groups.updated_at = curdate()
        where sch.district_id= #{@district.id}
      "
      )
      ActiveRecord::Base.connection.execute query
    end

    def insert_update_delete
      delete
            update
            insert
    end

    def delete
      query ="
       delete from g using  groups g 
       left outer join #{temporary_table_name} tg 
       on tg.district_group_id = g.district_group_id
       inner join schools sch on g.school_id = sch.id and sch.district_id= #{@district.id}
       where tg.district_school_id is null and sch.district_school_id is not null
        "
      ActiveRecord::Base.connection.execute query
    end

    def insert
      
      
      query=("insert into groups
      (school_id, district_group_id, title, created_at, updated_at)
      select sch.id, tg.district_group_id, tg.name, curdate(), curdate() from #{temporary_table_name} tg
      inner join schools sch on sch.district_school_id = tg.district_school_id
      left outer join groups g on g.district_group_id = tg.district_group_id
      where sch.district_id= #{@district.id} and g.id is null
      and sch.district_school_id is not null
      "
      )
      ActiveRecord::Base.connection.execute query
    end
  end
end

