module CSVImporter
  class StudentGroups < CSVImporter::Base

   #<Benchmark::Tms:0x41da63f8 @real=1328.59576916695, @utime=0.0200000000000005, @cstime=0.77, @cutime=20.16, @label="", @total=20.97, @stime=0.02>
   #884 SECONDS NOW.. (there wasn't anything to delete)  delete took 937..   1792 total with delete...    630 seconds after initial load now
   

  private
    def index_options
      [[:district_student_id, :district_group_id]]
    end

    def csv_headers
      [:district_student_id, :district_group_id]
    end

    def temporary_table?
      false
    end

    def migration t
      t.integer :district_student_id
      t.string :district_group_id
    end

    def delete
    query = "delete from sg using groups_students sg
              inner join students on sg.student_id = students.id
              inner join groups on sg.group_id = groups.id
              inner join schools on groups.school_id = schools.id
              where schools.district_id = #{@district.id} and students.district_id = #{@district.id}
              and not exists (
                                          select 1 from #{temporary_table_name} tug
                                                  where tug.district_student_id = students.id_district and tug.district_group_id = groups.id_district
                                                        )"

      puts query                                                        
      UserGroupAssignment.connection.execute query
    end

    def insert
      query=("insert into groups_students
      (student_id,group_id)
      select u.id , g.id from #{temporary_table_name} tug inner join 
      students u on u.id_district = tug.district_student_id
      inner join groups g
      on tug.district_group_id = g.id_district
      and u.district_id = #{@district.id}  
      where not exists (
      select 1 from groups_students gs
        where gs.group_id = g.id and gs.student_id = u.id)
      "
      )
      puts query
      Group.connection.execute query
    end


   def insert_update_delete
     delete
     insert
   end
  end
end
