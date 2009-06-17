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
