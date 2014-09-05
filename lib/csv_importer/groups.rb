module CSVImporter
  class Groups < CSVImporter::Base
    #    77.6728281974792
    #
    FIELD_DESCRIPTIONS = {
      :district_group_id =>"Key for group, this could be a string.  I recommend using a prefix, so sect314 would represent a section with a primary key of 314, then nei445 could be a neighborhood with id 445.   Keys must be unique so this is necessary if you're going to be combining data from different tables from your student information system (20 char limit)",
      :district_school_id =>"Key for school",
      :name =>"The name of the group that will appear in SIMS."
    }
    
    
    class << self
      def description
        "Named collections of students within a school. It could be classroom sections of students, neighborhoods, teams. Students and Users get assigned to them."
      end

      def csv_headers
        [:district_group_id, :district_school_id, :name]
      end
      def overwritten
      end

      def load_order
      end

      def removed
      end

#      def related
#      end

      def how_often
        "Once per semester (or quarter), or as often as the \"students\" file is uploaded"
      end

#      def alternate
#      end

      def how_many_rows
        "There should be one row per group.  A school will have multiple groups."
      end

      def upload_responses
        super
      end

    end


  private
    def index_options
      [[:district_group_id, :district_school_id] ]
    end

    def sims_model
      Group
    end

    def migration t
      @cols = sims_model.columns_hash.merge(School.columns_hash)

      csv_headers.each do |col|
        c=col.to_s
        t.column col, @cols[c].type, :limit => @cols[c].limit, :null => @cols[c].null
      end
    end


    def temporary_table?
      true
    end

    def remove_duplicates?
      true
    end

    def remove_duplicates
      v=Group.connection.select_values "select concat('duplicate groups for ' ,district_group_id,' and ', district_school_id , ' using one titled ' , max(name))
      from #{temporary_table_name} group by district_group_id,district_school_id having count(name) > 1"
      @other_messages << v.join("; ") unless v.blank?
    end


    def update
      query=("update groups
        inner join  #{temporary_table_name} tg on tg.district_group_id = groups.district_group_id
        inner join schools sch on sch.district_school_id = tg.district_school_id and groups.school_id = sch.id
        set groups.school_id = sch.id, groups.district_group_id = tg.district_group_id, groups.title = tg.name,  groups.updated_at = curdate()
        where sch.district_id= #{@district.id} and sch.district_school_id is not null and groups.district_group_id != ''
      "
      )
      ActiveRecord::Base.connection.update query
    end

    def delete
      query1 ="
       delete from gs, uga  using  groups g
       left outer join #{temporary_table_name} tg
       on tg.district_group_id = g.district_group_id
       inner join schools sch on g.school_id = sch.id and sch.district_id= #{@district.id}
       left outer join user_group_assignments uga on uga.group_id = g.id
       left outer join groups_students gs on gs.group_id = g.id
       where tg.district_school_id is null and sch.district_school_id is not null and g.district_group_id != ''
        "

      query2 ="
       delete from g  using  groups g
       left outer join #{temporary_table_name} tg
       on tg.district_group_id = g.district_group_id
       inner join schools sch on g.school_id = sch.id and sch.district_id= #{@district.id}
       where tg.district_school_id is null and sch.district_school_id is not null and g.district_group_id != ''
        "
       ActiveRecord::Base.connection.update query1
       ActiveRecord::Base.connection.update query2
    end

    def insert
      query=("insert into groups
      (school_id, district_group_id, title, created_at, updated_at)
      select sch.id, tg.district_group_id, max(tg.name) as name, curdate(), curdate() from #{temporary_table_name} tg
      inner join schools sch on sch.district_school_id = tg.district_school_id
      left outer join groups g on g.district_group_id = tg.district_group_id
      where sch.district_id= #{@district.id} and g.id is null
      and sch.district_school_id is not null
      group by tg.district_group_id,tg.district_school_id
      "
      )
      ActiveRecord::Base.connection.update query
    end

  end
end

