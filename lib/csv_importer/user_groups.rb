module CSVImporter
  class UserGroups < CSVImporter::Base
    #125.01763010025 seconds!
    #135 with district constrained delete
    #
    #
    FIELD_DESCRIPTIONS = { 
    district_user_id: 'Key for user',
    district_group_id: "Key for group (the one you created for the SIMS group.)",
    principal: "true if the user is the principal for that group, blank otherwise.   
The most common case this would be used would be for assistant principals assigned to teams or neighborhoods.  
Schoolwide (or asst principals by grade) would be covered by all_students_in_school.csv  (Y/N also works)"
}
    class << self
      def description
        "Assigns users to groups."
      end

      def csv_headers
        [:district_user_id, :district_group_id, :principal]
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

      def upload_responses
        super
      end

      def how_many_rows
        "One row per user per group.   A group might have one or multiple users, and a user could be assigned to multiple groups."
      end
    end

    private

    def load_data_infile
      headers=csv_headers
      headers[-1]="@principal"
      <<-EOF
          LOAD DATA LOCAL INFILE "#{@clean_file}" 
            INTO TABLE #{temporary_table_name}
            FIELDS TERMINATED BY ','
            OPTIONALLY ENCLOSED BY '"'
            (#{headers.join(", ")})
        set    principal= case trim(lower(@principal)) 
        when 't' then true 
        when 'y' then true 
        when 'yes' then true 
        when 'true' then true 
        when '-1' then true 
        when '1' then true 
        else false 
        end ;
        EOF
    end
 
    def index_options
      [[:district_user_id, :district_group_id]]
    end

    def migration t
      t.string :district_user_id, limit: User.columns_hash["district_user_id"].limit, null: User.columns_hash["district_user_id"].null
      t.string :district_group_id, limit: Group.columns_hash["district_group_id"].limit, null: Group.columns_hash["district_group_id"].null
      t.boolean :principal
    end

    def delete
      query = "delete from uga using user_group_assignments uga
      inner join users on uga.user_id = users.id
      inner join groups on uga.group_id = groups.id
      inner join schools on groups.school_id = schools.id
      where schools.district_id = #{@district.id} and users.district_id = #{@district.id} and schools.district_school_id is not null and groups.district_group_id !='' and users.district_user_id !=''
      "

      extra ="      where not exists (
              select 1 from #{temporary_table_name} tug
              where tug.district_user_id = users.district_user_id and tug.district_group_id = groups.district_group_id)
            )"
      UserGroupAssignment.connection.update query
    end

    def insert
      query=("insert into user_group_assignments
      (user_id,group_id, is_principal, created_at, updated_at)
      select u.id , g.id, principal, CURDATE(), CURDATE() from #{temporary_table_name} tug inner join 
      users u on u.district_user_id = tug.district_user_id
      inner join groups g
      on tug.district_group_id = g.district_group_id
      and u.district_id = #{@district.id}  
      group by u.id,g.id,principal
      "
      )
      Group.connection.update query
    end
  end
end
