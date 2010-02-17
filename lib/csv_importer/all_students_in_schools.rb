module CSVImporter
  class AllStudentsInSchools < CSVImporter::Base

  private
    def index_options
      [[:district_user_id, :district_school_id]]
    end

    def csv_headers
      [:district_user_id, :district_school_id, :principal, :grade]
    end

    def migration t
      t.string :district_user_id
      t.integer :district_school_id
      t.boolean :principal
      t.string :grade
      t.string :district_group_id
    end

    def delete
      query = "delete from sug using special_user_groups sug
      inner join users on sug.user_id = users.id
      inner join schools on schools.id = sug.school_id
      where schools.district_id = #{@district.id} and users.district_id = #{@district.id}
      and sug.grouptype = #{SpecialUserGroup::ALL_STUDENTS_IN_SCHOOL}
      "

     SpecialUserGroup.connection.execute query
    end

    def insert

      query=("insert into special_user_groups
      (user_id,school_id,grouptype,district_id,is_principal,grade, created_at, updated_at)
      select u.id ,schools.id, #{SpecialUserGroup::ALL_STUDENTS_IN_SCHOOL},#{@district.id},tug.principal, nullif(tug.grade,''), CURDATE(), CURDATE() from #{temporary_table_name} tug inner join 
      users u on u.district_user_id = tug.district_user_id
      inner join schools on tug.district_school_id = schools.district_school_id
      where u.district_id = #{@district.id}  and schools.district_id = #{@district.id}
      "
      )
      SpecialUserGroup.connection.execute query
    end
  end
end

