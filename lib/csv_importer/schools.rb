module CSVImporter
  class Schools < CSVImporter::Base
#
    FIELD_DESCRIPTIONS = { 
      :district_example_id => 'the primary key used in the student information system by the district',
      :example_text => 'some other field'
    }
    class << self
      def description
        "Schools in the district"
      end

      def csv_headers
        [:district_example_id, :example_text]
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
      [:district_school_id]
    end

    def csv_headers
     [:district_school_id, :name]
    end

    def sims_model
      School
    end

    def migration t
      t.column :district_school_id, :integer
      t.column :name, :string
   end


    def update
      query = "update schools s inner join 
      #{temporary_table_name} ts on ts.district_school_id = s.district_school_id and s.district_id = #{@district.id}
      and s.district_school_id is not null
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
      on ts.district_school_id=s.district_school_id
      where s.district_id=#{@district.id} and  s.district_school_id is not null and ts.district_school_id is null" 
      ActiveRecord::Base.connection.execute(query)
    end

    def insert
      query=("insert into schools
      (district_school_id, name, created_at, updated_at, district_id)
      select ts.district_school_id, ts.name,  CURDATE(), CURDATE(), #{@district.id} from #{temporary_table_name} ts 
      left outer join schools s  
      on ts.district_school_id = s.district_school_id
      and s.district_id = #{@district.id} 
      where s.id is null and ts.district_school_id is not null
      "
      )
      puts query
      Group.connection.execute query
    end
  end
end
