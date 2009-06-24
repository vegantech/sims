module CSVImporter
  class Schools < CSVImporter::Base

  private
    def index_options
      [:id_district]
    end

    def csv_headers
     [:id_district, :name]
    end

    def sims_model
      School
    end

    def migration t
      cols = sims_model.columns.inject({}){|hash, col| hash[col.name.to_sym] = col.type; hash}

      csv_headers.each do |col|
        t.column :col, cols[col]
      end
   end


    def update
    end

    def insert_update_delete
      update
      insert
      delete
    end

    def delete
      puts 'FIX DELETE, you do not actually want to delete everyone'
      Student.delete_all(:district_id => @district.id)
    end

    def insert
      query=("insert into schools
      (id_district, name, created_at, updated_at)
      select tg.id_district, tg.name,  CURDATE(), CURDATE() from csv_importer tg inner join schools s  
      on tg.id_ = s.id_district
      and s.district_id = #{@district.id}  
      "
      )
      Group.connection.execute query
    end
  end
end



module ImportCSV::Schools
  def load_schools_from_csv file_name
    @schools = School.find_all_by_district_id(@district.id).hash_by(:id_district)
    if load_from_csv file_name, 'school'
      @district.schools.scoped(:conditions => ["id_district is not null and id not in (?)",@ids]).destroy_all
      bulk_update School
      bulk_insert School
    end
  end
  
  def process_school_line line
    found_school = @schools[line[:id_district].to_i] || @district.schools.build
    process_line line, found_school
  end
end
