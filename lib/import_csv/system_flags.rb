module ImportCSV::SystemFlags
  
  def load_system_flags_from_csv file_name
    @student_ids_by_id_district = ids_by_id_district Student
    if load_from_csv file_name, 'system_flag'
      SystemFlag.scoped(:include => :student, :conditions => ["students.district_id => ? and students.id_district is not null", @district.id]).delete_all
      bulk_insert SystemFlag
    end
  end

  def process_system_flags_line
    category = line[:category].downcase
    student_id_district =  line[:student_id_district].to_i

    if flag:FLAGTYPES.keys.include?(category)
      student_id = @student_ids_by_id_district[student_id_district]
      @inserts << SystemFlag.new(:student_id => student_id, :category => category, :reason => line[:reason])
    end
  end
end

