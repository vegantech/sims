module CSVImporter
  class StudentGroups < CSVImporter::Base

   #<Benchmark::Tms:0x41da63f8 @real=1328.59576916695, @utime=0.0200000000000005, @cstime=0.77, @cutime=20.16, @label="", @total=20.97, @stime=0.02>
  private
    def index_options
      [[:district_student_id, :district_group_id]]
    end

    def csv_headers
      [:district_student_id, :district_group_id]
    end

    def migration t
      t.integer :district_student_id
      t.string :district_group_id
    end

    def delete
      puts 'FixDelete, you do not want to delete everyone'
      #   ActiveRecord::Base.connection.execute('truncate table groups_students;')
      #UserGroupAssignment.delete_all
    end

    def insert
      query=("insert into groups_students
      (student_id,group_id)
      select u.id , g.id from csv_importer tug inner join 
      students u on u.id_district = tug.district_student_id
      inner join groups g
      on tug.district_group_id = g.id_district
      and u.district_id = #{@district.id}  
      "
      )
      puts query
      Group.connection.execute query
    end
  end
end
