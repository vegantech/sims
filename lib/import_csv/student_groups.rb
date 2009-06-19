module ImportCSV::StudentGroups
  class StudentGroupAssignment
    CSV_HEADERS = [:district_student_id, :district_group_id]
  end
  def load_student_groups_from_csv  file_name
   #<Benchmark::Tms:0x41da63f8 @real=1328.59576916695, @utime=0.0200000000000005, @cstime=0.77, @cutime=20.16, @label="", @total=20.97, @stime=0.02>
    if confirm_student_groups_header file_name
      clean_student_groups_csv_file file_name
      create_temporary_student_groups_table
      load_student_groups_into_temporary_student_groups_table
      ActiveRecord::Migration.add_index :temporary_student_groups, [:district_student_id,:district_group_id], :name => :temporary_student_group
      remove_existing_student_groups
      load_new_student_groups
      drop_temporary_student_groups_table
      #confirm header
      #remove header, remove empty lines, remove ---'s, strip whitespace
      #import into temp tablea
    end
  end

  def remove_existing_student_groups
    UserGroupAssignment.delete_all
  end

  def load_new_student_groups
    inserts = User::CSV_HEADERS.join(", ")
    query=("insert into groups_students
    (student_id,group_id)
    select u.id , g.id from temporary_student_groups tug inner join 
    students u on u.id_district = tug.district_student_id
    inner join groups g
    on tug.district_group_id = g.id_district
    and u.district_id = #{@district.id}  
    "
    )
    puts query
    Group.connection.execute query
  end


  def create_temporary_student_groups_table
     ActiveRecord::Migration.create_table :temporary_student_groups,  :id => false  , :temporary => false, :force=>true do |t|
       t.integer :district_student_id
       t.string :district_group_id
     end

     # ActiveRecord::Migration.add_index :students,:id_district
  end

  def drop_temporary_student_groups_table
    ActiveRecord::Migration.drop_table :temporary_student_groups
    #ActiveRecord::Migration.remove_index :students, :id_district
  end

  def load_student_groups_into_temporary_student_groups_table
    Group.connection.execute load_data_infile('/tmp/clean_student_groups.csv', 'temporary_student_groups', StudentGroupAssignment)
  end



  def load_data_infile(temp_path, table_name ='temporary_users', const=User)
    <<-EOF
        LOAD DATA INFILE "#{temp_path}" 
          INTO TABLE #{table_name}
          FIELDS TERMINATED BY ','
          (#{const::CSV_HEADERS.join(", ")})
          ;
      EOF
  end


  def confirm_student_groups_header file_name
    if  `head -n1 #{file_name}`.strip == StudentGroupAssignment::CSV_HEADERS.join(",")
      puts 'good student_groups.csv'
      return true
    else
      puts 'fial'
      @messages << "Invalid file,  file must have headers #{ StudentGroupAssignment::CSV_HEADERS.join(",")}"
      return false
    end
  end

  def clean_student_groups_csv_file file_name
    system "tail -n +3 #{file_name} |head -n -2| sed -e 's/ [ ]*//g' -e 's/\r//' > /tmp/clean_student_groups.csv"
  end
  
end
