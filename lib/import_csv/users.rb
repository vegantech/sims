module ImportCSV::Users

  def load_users_from_csv2 file_name
    #27 seconds for rerunning, 29 seconds for initial upload
    cf=clean_users_file file_name
    create_temporary_users_table
    load_users_into_temporary_users_table
    update_existing_users
    insert_missing_users
    remove_other_users
    drop_temporary_users_table
  end

  def load_users_into_temporary_users_table
    User.connection.execute load_data_infile('/tmp/clean_users.csv')
  end

  def clean_users_file file_name
    #about 12 seconds for 24866 lines
    input   = FasterCSV.read(file_name, ImportCSV::DEFAULT_CSV_OPTS)
    FasterCSV.open('/tmp/clean_users.csv',"w") do |csv|

      input.each do |row|
        next  if row[0] =~  /^-+|\(\d+ rows affected\)$/
        csv << row
      end
    end
        
    #open the file,
    #clean each line, remove the line if it is bogus and add a message write the new line to a clean file
    #r
  end

  def create_temporary_users_table
    [:id_district, :username, :first_name, :last_name, :middle_name, :suffix, :email, :passwordhash, :salt]
     ActiveRecord::Migration.create_table :temporary_users,  :id => false  , :temporary => true do |t|
       t.integer :id_district
       t.string :username
       t.string :first_name
       t.string :last_name
       t.string :middle_name
       t.string :suffix
       t.string :email
       t.string :passwordhash
       t.string :salt
     end

     #ActiveRecord::Migration.add_index :users,:id_district
       ActiveRecord::Migration.add_index :temporary_users, :id_district
  end

  def drop_temporary_users_table
    ActiveRecord::Migration.drop_table :temporary_users
  end

  def load_data_infile(temp_path)
    <<-EOF
        LOAD DATA INFILE "#{temp_path}" 
          INTO TABLE temporary_users
          FIELDS TERMINATED BY ','
          (#{User::CSV_HEADERS.join(", ")})
          ;
      EOF
  end

  def update_existing_users 
    updates=User::CSV_HEADERS.collect{|e| "u.#{e} = tu.#{e}"}.join(", ")
    User.connection.execute("update users u
      inner join temporary_users tu
      on u.id_district = tu.id_district and u.id_district is not null
      set u.updated_at=CURDATE(), 
      #{updates}
    where district_id = #{@district.id}"
    
    )
  end

  def remove_other_users
    query = "delete  from u
    using users u 
    left outer join temporary_users tu 
    on u.id_district = tu.id_district
    where u.id_district is not null and u.district_id = #{@district.id}
    and tu.id_district is null"
    User.connection.execute query
  end

  def insert_missing_users
    inserts = User::CSV_HEADERS.join(", ")
    query=("insert into users 
    (#{inserts}, created_at, updated_at, district_id)
    select tu.* , CURDATE(), CURDATE(), #{@district.id} from temporary_users tu left outer join users u  
    on tu.id_district = u.id_district
    and u.district_id = #{@district.id}  
    where
    u.id_district is null
    and tu.id_district is not null
    "
    )
    User.connection.execute query
  end

  
                                                                                                                                                                                             
  
  def load_users_from_csv file_name
    #with db
    #=> #<Benchmark::Tms:0x4344ffc8 @real=1669.30910181999, @utime=1398.7, @cstime=0.0, @cutime=0.0, @label="", @total=1593.06, @stime=194.36>
    #without db
    #=> #<Benchmark::Tms:0x426ad0b4 @real=22.8795781135559, @utime=22.8399999999999, @cstime=0.0, @cutime=0.0, @label="", @total=22.8699999999999, @stime=0.0300000000000011>
    # preloading existing users, splittng update and create to use w/o callbacks private methods
    #=> #<Benchmark::Tms:0x459f75b4 @real=260.481770992279, @utime=167.44, @cstime=0.0, @cutime=0.0, @label="", @total=202.95, @stime=35.51>

    # #<Benchmark::Tms:0x426fc4ac @real=87.2511579990387, @utime=85.85, @cstime=0.0, @cutime=0.0, @label="", @total=87.24, @stime=1.39> in production mode with inserts
    # all in a transactiona
    # @real=96.9692440032959 same as above, but in development.       all tests so far are using sqlite3

    #46 seconds when redoing duplicate file
    #131.687636852264 seconds for full update
    
    @users = User.find_all_by_district_id(@district.id).hash_by(:username)
    if load_from_csv file_name,  "user"
      
        bulk_update User  #update
        @district.users.scoped(:conditions => ["id_district is not null and id not in (?)",@ids]).destroy_all  #delete
        #TODO deletion should only occur for users that have no activity
        #delete must be before insert, since they don't have ids yet

        bulk_insert User
    else
      false
    end
  end

  def process_user_line  line
    found_user = @users[line[:username]]  || @district.users.build
    process_line line, found_user
  end
end

