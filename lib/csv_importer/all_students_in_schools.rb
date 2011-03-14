module CSVImporter
  class AllStudentsInSchools < CSVImporter::Base

    FIELD_DESCRIPTIONS = { 
      :district_user_id => 'Key for user',
      :district_school_id =>"Key for school",
      :principal =>"True if the user is the principal of this group (or school)  otherwise blank",
      :grade =>"Should match grade in enrollments.  Leave blank for all students in school instead of limiting to a specific grade"
    }

    class << self
      def description
        "List of users with access to all students in a given school, or all students in a given grade. Be sure to also give them regular user access.
        Users in this file will automatically assigned to this school."
      end
      
      def file_name
        "all_students_in_school.csv"
      end

      def csv_headers
        [:district_user_id, :district_school_id, :principal, :grade]
      end

      def overwritten
      end

      def load_order
        "This should be uploaded after schools and users and after user_school_assignments."
      end

      def removed
      end

#      def related
#      end

      def how_often
         "Start of each semester (depending on frequency of new staff may need to be done more or less often; should be done at same time as the \"users\" file)."
      end

      def how_many_rows
        "One row for each user per school.  If a school has multiple users then it will have multiple rows.  
        If a user has access to multiple schools, then they will have multiple rows."
      end

#      def alternate
#      end

      def upload_responses
        super
      end

    end

  private

    def load_data_infile
      headers=csv_headers
      headers[-2]="@principal"
      <<-EOF
          LOAD DATA LOCAL INFILE "#{@clean_file}" 
            INTO TABLE #{temporary_table_name}
            FIELDS TERMINATED BY ','
            OPTIONALLY ENCLOSED BY '"'
            (#{headers.join(", ")})
            set principal= case trim(lower(@principal)) 
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
      [[:district_user_id, :district_school_id]]
    end


    def migration t
      t.string :district_user_id, :limit => User.columns_hash["district_user_id"].limit, :null => User.columns_hash["district_user_id"].null
      t.integer :district_school_id, :limit => School.columns_hash["district_school_id"].limit, :null => School.columns_hash["district_school_id"].null
      t.boolean :principal
      t.string :grade
      t.string :district_group_id, :limit => Group.columns_hash["district_group_id"].limit, :null => Group.columns_hash["district_group_id"].null
    end

    def remove_duplicates?
      true
    end

    def delete
      query = "delete from sug using special_user_groups sug
      inner join users on sug.user_id = users.id
      inner join schools on schools.id = sug.school_id
      where schools.district_id = #{@district.id} and users.district_id = #{@district.id}
      and sug.grouptype = #{SpecialUserGroup::ALL_STUDENTS_IN_SCHOOL}
      and users.district_user_id != '' and schools.district_school_id is not null
      "

     SpecialUserGroup.connection.update query
    end

    def insert

      query=("insert into special_user_groups
      (user_id,school_id,grouptype,district_id,is_principal,grade, created_at, updated_at)
      select u.id ,schools.id, #{SpecialUserGroup::ALL_STUDENTS_IN_SCHOOL},#{@district.id},tug.principal, nullif(tug.grade,''), CURDATE(), CURDATE() from #{temporary_table_name} tug inner join 
      users u on u.district_user_id = tug.district_user_id
      inner join schools on tug.district_school_id = schools.district_school_id
      where u.district_id = #{@district.id}  and schools.district_id = #{@district.id}
      and schools.district_school_id is not null
      "
      )
      SpecialUserGroup.connection.update query
    end

    def after_import
      sum=@district.special_user_groups.autoassign_user_school_assignments
     query= "insert into user_school_assignments (school_id,user_id) 
      select sug.school_id, sug.user_id from special_user_groups sug 
      left outer join user_school_assignments uga on uga.user_id = sug.user_id and uga.school_id = uga.school_id 
      inner join users on sug.user_id = users.id 
      where grouptype=3 and uga.user_id is null and users.district_id = #{@district.id} and sug.district_id = #{@district.id}
      group by sug.school_id,sug.user_id"
      sum=SpecialUserGroup.connection.update query
      @messages << "#{sum} Users automatically assigned to a school" if sum > 0
    end
  end
end

