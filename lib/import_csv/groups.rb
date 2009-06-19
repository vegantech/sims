module ImportCSV::Groups
  ::Group::CSV_HEADERS = [:district_group_id, :district_school_id, :name]
  def load_groups_from_csv  file_name
    #47 seconds
    if confirm_groups_header file_name
      clean_groups_csv_file file_name
      create_temporary_groups_table
      load_group_into_temporary_users_table
      remove_existing_groups
      load_new_groups
      drop_temporary_groups_table
      #confirm header
      #remove header, remove empty lines, remove ---'s, strip whitespace
      #import into temp tablea
    end
  end

  def remove_existing_groups
    Group.delete_all
  end

  def load_new_groups
    inserts = User::CSV_HEADERS.join(", ")
    query=("insert into groups
    (title,school_id,id_district, created_at, updated_at)
    select tg.name , s.id, tg.district_group_id , CURDATE(), CURDATE() from temporary_groups tg inner join schools s  
    on tg.district_school_id = s.id_district
    and s.district_id = #{@district.id}  
    "
    )
    Group.connection.execute query
  end


  def create_temporary_groups_table
     ActiveRecord::Migration.create_table :temporary_groups,  :id => false  , :temporary => false, :force=>true do |t|
       t.string :district_group_id
       t.string :district_school_id
       t.string :name
     end

       ActiveRecord::Migration.add_index :schools,:id_district
       ActiveRecord::Migration.add_index :temporary_groups, :district_school_id
  end

  def drop_temporary_groups_table
    ActiveRecord::Migration.drop_table :temporary_groups
    ActiveRecord::Migration.remove_index :schools, :id_district
  end

  def load_group_into_temporary_users_table
    Group.connection.execute load_data_infile('/tmp/clean_groups.csv', 'temporary_groups', Group)
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



  
  def confirm_groups_header file_name
    if  `head -n1 #{file_name}`.strip == Group::CSV_HEADERS.join(",")
      puts 'good groups.csv'
      return true
    else
      @messages << "Invalid file,  file must have headers #{ Group::CSV_HEADERS.join(",")}"
      return false
    end
  end

  def clean_groups_csv_file file_name
    system "tail -n +3 #{file_name} |head -n -2| sed -e 's/ [ ]*//g' > /tmp/clean_groups.csv"

  end

  def old_load_groups_from_csv
    @school_ids_by_id_district = ids_by_id_district School

    if load_from_csv file_name, "group"
      #Group.delete
      bulk_insert Group
    end
    
  end

  def process_group_line line
    school_id_district =  line[:school_id_district].to_i
    group_id_district = line[:district_group_id]
    name = line[:name]
    school_id = @school_ids_by_id_district[school_id_district]
    if school_id_district.present?
      @inserts << Group.new(:school_id => school_id, :name => name, :id_district => group_id_district)
    end
  end




  
end
