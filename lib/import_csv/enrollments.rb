module ImportCSV::Enrollments  
  def load_enrollments_from_csv  file_name
    #<Benchmark::Tms:0x430d52a8 @real=144.996875047684, @utime=141.65, @cstime=0.0, @cutime=0.0, @label="", @total=144.78, @stime=3.13>  all insert
    #<Benchmark::Tms:0x45067ecc @real=74.2686920166016, @utime=73.64, @cstime=0.0, @cutime=0.0, @label="", @total=74.14, @stime=0.5>  noop
    #<Benchmark::Tms:0x450a3b70 @real=149.988860845566, @utime=148.22, @cstime=0.0, @cutime=0.0, @label="", @total=149.86, @stime=1.64> 1/2 insert 1/2 update
    
    enrollments_from_db = Enrollment.all(:select => 'students.id_district as student_id_district, schools.id_district as school_id_district, enrollments.*',:joins=>[:student,:school],
    :conditions => ["schools.id_district is not null and schools.district_id = :district_id and students.id_district is not null and students.district_id = :district_id",
    {:district_id => @district.id}])
    
    @enrollments = enrollments_from_db.inject({}) do |hsh,obj| 
        hash_key_array = [obj[:student_id_district].to_i,obj[:school_id_district].to_i,obj[:end_year],obj[:grade]]
        
        hsh[ hash_key_array ] = obj[:id] ; hsh
      end
    

    @school_ids_by_id_district = ids_by_id_district School
    @student_ids_by_id_district = ids_by_id_district Student

    if load_from_csv file_name, "enrollment"
      #delete from search above where id not in @updates
      deletes = @enrollments.values - @updates
      Enrollment.delete(deletes)

      bulk_insert Enrollment
    end
        
  end

  def process_enrollment_line line
    student_id_district =  line[:student_id_district].to_i
    school_id_district =  line[:school_id_district].to_i
    grade = line[:grade]
    end_year = line[:end_year].to_i
    hash_key= [student_id_district, school_id_district, end_year, grade]

    
    found_enrollment_id = @enrollments[hash_key]
    if found_enrollment_id
      @updates << found_enrollment_id
    else
      student_id = @student_ids_by_id_district[student_id_district]
      school_id = @school_ids_by_id_district[school_id_district]
      @inserts << Enrollment.new(:student_id => student_id, :school_id =>school_id, :grade => grade, :end_year => end_year)
    end
  end
end
