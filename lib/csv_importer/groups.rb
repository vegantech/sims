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
        inner join  #{temporary_table_name} tg on tg.district_group_id = groups.id_district
        inner join schools sch on sch.id_district = tg.district_school_id
        set groups.school_id = sch.id, groups.id_district = tg.district_group_id, groups.title = tg.name,  groups.updated_at = curdate()
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
       on tg.district_group_id = g.id_district
       inner join schools sch on g.school_id = sch.id and sch.district_id= #{@district.id}
       where tg.district_school_id is null and sch.id_district is not null
        "
      ActiveRecord::Base.connection.execute query
    end

    def insert
      #Group(id: integer, title: string, school_id: integer, created_at: datetime, updated_at: datetime, id_district: string)
      
      
      query=("insert into groups
      (school_id, id_district, title, created_at, updated_at)
      select sch.id, tg.district_group_id, tg.name, curdate(), curdate() from #{temporary_table_name} tg
      inner join schools sch on sch.id_district = tg.district_school_id
      left outer join groups g on g.id_district = tg.district_group_id
      where sch.district_id= #{@district.id} and g.id is null
      and sch.id_district is not null
      "
      )
      ActiveRecord::Base.connection.execute query
    end
  end
end


=begin
    def insert
      query=("insert into enrollments
      (school_id, student_id, grade, end_year , created_at, updated_at)
      select sch.id, stu.id, te.grade, te.end_year, curdate(), curdate() from #{temporary_table_name} te
      inner join schools sch on sch.id_district = te.school_id_district
      inner join students stu on stu.id_district = te.student_id_district
      left outer join enrollments e
      on sch.id = e.school_id and stu.id = e.student_id and te.grade = e.grade and te.end_year = e.end_year
      where sch.district_id= #{@district.id} and stu.district_id = #{@district.id}
      and e.school_id is null and stu.id_district is not null and sch.id_district is not null
      "
      )
      ActiveRecord::Base.connection.execute query
    end
   def confirm_count?
      model_name = sims_model.name
    model_count = @district.send(model_name.tableize).count
    if @line_count < (model_count * ImportCSV::DELETE_PERCENT_THRESHOLD  ) && model_count > ImportCSV::DELETE_COUNT_THRESHOLD
      @messages << "Probable bad CSV file.  We are refusing to delete over 40% of your #{model_name.pluralize} records."
      false
    else
      true
    end
    end
 


  end
end
=end
