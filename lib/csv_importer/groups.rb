module CSVImporter
  class Groups < CSVImporter::Base
    #    77.6728281974792
    #
    FIELD_DESCRIPTIONS = { 
      :district_group_id =>"Key for group, this could be a string.  I recommend using a prefix, so sect314 would represent a section with a primary key of 314, then nei445 could be a neighborhood with id 445.   Keys must be unique so this is necessary if you're going to be combining data from different tables from your student information system",
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
        "What will get overwritten/changed when this file is uploaded."
      end

      def load_order
        "When to upload this file in relation to other files."
      end

      def removed
        "What gets removed when this file is uploaded."
      end

      def related
        "links to related files with explanations."
      end

      def how_often
        "Notes on how often this file should be imported after initial import."
      end

      def alternate
        "links to files that can be used instead of this one, with explanation."
      end

      def upload_responses
        "What you see on the screen or in the email after uploading this file and what the different messages mean. <br />
        In this case you'll see unknown file examples.csv"
      end

    end


  private
    def index_options
      [[:district_group_id, :district_school_id] ]
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
       where tg.district_school_id is null and sch.district_school_id is not null and g.district_group_id is not null and g.district_group_id != ''
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

