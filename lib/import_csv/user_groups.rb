module ImportCSV::UserGroups
  ::UserGroupAssignment::CSV_HEADERS = [:district_user_id, :district_group_id]
  def load_user_groups_from_csv  file_name
    #125.01763010025 seconds!
    if confirm_user_groups_header file_name
      clean_user_groups_csv_file file_name
      create_temporary_user_groups_table
      load_user_groups_into_temporary_user_groups_table
      remove_existing_user_groups
      load_new_user_groups
      drop_temporary_user_groups_table
      #confirm header
      #remove header, remove empty lines, remove ---'s, strip whitespace
      #import into temp tablea
    end
  end

  def remove_existing_user_groups
    UserGroupAssignment.delete_all
  end

  def load_new_user_groups
    inserts = User::CSV_HEADERS.join(", ")
    query=("insert into user_group_assignments
    (user_id,group_id, created_at, updated_at)
    select u.id , g.id, CURDATE(), CURDATE() from temporary_user_groups tug inner join 
    users u on u.id_district = tug.district_user_id
    inner join groups g
    on tug.district_group_id = g.id_district
    and u.district_id = #{@district.id}  
    "
    )
    puts query
    Group.connection.execute query
  end


  def create_temporary_user_groups_table
     ActiveRecord::Migration.create_table :temporary_user_groups,  :id => false  , :temporary => false, :force=>true do |t|
       t.integer :district_user_id
       t.string :district_group_id
     end

     # ActiveRecord::Migration.add_index :users,:id_district
     #       ActiveRecord::Migration.add_index :temporary_user_groups, [:district_user_id,:district_group_id]
  end

  def drop_temporary_user_groups_table
    ActiveRecord::Migration.drop_table :temporary_user_groups
    #ActiveRecord::Migration.remove_index :users, :id_district
  end

  def load_user_groups_into_temporary_user_groups_table
    Group.connection.execute load_data_infile('/tmp/clean_user_groups.csv', 'temporary_user_groups', UserGroupAssignment)
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


  def confirm_user_groups_header file_name
    if  `head -n1 #{file_name}`.strip == UserGroupAssignment::CSV_HEADERS.join(",")
      puts 'good user_groups.csv'
      return true
    else
      puts 'fial'
      @messages << "Invalid file,  file must have headers #{ UserGroup::CSV_HEADERS.join(",")}"
      return false
    end
  end

  def clean_user_groups_csv_file file_name
    system "tail -n +3 #{file_name} |head -n -2| sed -e 's/ [ ]*//g' -e 's/\r//' > /tmp/clean_user_groups.csv"
  end
  
end
