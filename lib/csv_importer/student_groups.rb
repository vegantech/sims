module CSVImporter
  class StudentGroups < CSVImporter::Base

   #<Benchmark::Tms:0x41da63f8 @real=1328.59576916695, @utime=0.0200000000000005, @cstime=0.77, @cutime=20.16, @label="", @total=20.97, @stime=0.02>
   #884 SECONDS NOW.. (there wasn't anything to delete)  delete took 937..   1792 total with delete...    630 seconds after initial load now
  FIELD_DESCRIPTIONS = { 
      :district_user_id => 'Key for user'
    }

    
    class << self
      def description
        "Assigns students to groups."
      end

      def csv_headers
        [:district_user_id, :username, :first_name, :middle_name, :last_name, :suffix, :email, :passwordhash, :salt]
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
      [[:district_student_id, :district_group_id]]
    end

    def csv_headers
      [:district_student_id, :district_group_id]
    end

    def temporary_table?
      true
    end

    def migration t
      t.string :district_student_id
      t.string :district_group_id
    end

    def delete
    query = "delete from sg using groups_students sg
              inner join students on sg.student_id = students.id
              inner join groups on sg.group_id = groups.id
              inner join schools on groups.school_id = schools.id
              where schools.district_id = #{@district.id} and students.district_id = #{@district.id} and groups.district_group_id is not null and groups.district_group_id !=''
              and not exists (
                                          select 1 from #{temporary_table_name} tug
                                                  where tug.district_student_id = students.district_student_id and tug.district_group_id = groups.district_group_id
                                                        )"

      puts query                                                        
      UserGroupAssignment.connection.execute query
    end

    def insert
      query=("insert into groups_students
      (student_id,group_id)
      select u.id , g.id from #{temporary_table_name} tug inner join 
      students u on u.district_student_id = tug.district_student_id
      inner join groups g
      on tug.district_group_id = g.district_group_id
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
