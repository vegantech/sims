module CSVImporter
  class StudentGroups < CSVImporter::Base

   #<Benchmark::Tms:0x41da63f8 @real=1328.59576916695, @utime=0.0200000000000005, @cstime=0.77, @cutime=20.16, @label="", @total=20.97, @stime=0.02>
   #884 SECONDS NOW.. (there wasn't anything to delete)  delete took 937..   1792 total with delete...    630 seconds after initial load now
  FIELD_DESCRIPTIONS = { 
      :district_student_id => 'Key for student',
      :district_group_id => 'Key for group (the one you created for the SIMS group.)'
    }

    
    class << self
      def description
        "Assigns students to groups."
      end

      def csv_headers
        [:district_student_id, :district_group_id]
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
        "One row per student per group.  A student will have multiple groups and a group will contain multiple students."
      end
      def upload_responses
        super
      end

    end

  

  private
    def index_options
      [[:district_student_id, :district_group_id]]
    end


    def temporary_table?
      true
    end

    def migration t
      t.string :district_student_id, :limit => Student.columns_hash["district_student_id"].limit, :null => Student.columns_hash["district_student_id"].null
      t.string :district_group_id, :limit => Group.columns_hash["district_group_id"].limit, :null => Group.columns_hash["district_group_id"].null
    end

    def delete
    query = "delete from sg using groups_students sg
              inner join students on sg.student_id = students.id
              inner join groups on sg.group_id = groups.id
              inner join schools on groups.school_id = schools.id
              where schools.district_id = #{@district.id} and students.district_id = #{@district.id} and schools.district_school_id is not null and groups.district_group_id !=''
              and students.district_student_id != ''
              and not exists (
                                          select 1 from #{temporary_table_name} tug
                                                  where tug.district_student_id = students.district_student_id and tug.district_group_id = groups.district_group_id
                                                        )"

      UserGroupAssignment.connection.update query
    end

    def insert
      query=("insert into groups_students
      (student_id,group_id)
      select u.id , g.id from #{temporary_table_name} tug inner join 
      students u on u.district_student_id = tug.district_student_id
      inner join groups g
      on tug.district_group_id = g.district_group_id
      and u.district_id = #{@district.id}  
      inner join schools sch
      on g.school_id = sch.id and sch.district_id = #{@district.id}
      where not exists (
      select 1 from groups_students gs
        where gs.group_id = g.id and gs.student_id = u.id)
      group by u.id,g.id
      "
      )
      Group.connection.update query
    end


    def insert_update_delete
      @deleted=delete
      @created=insert
    end


 end
end
