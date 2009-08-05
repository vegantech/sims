class ImportMMSD
  


  #1. do ic import

  #tier
  #recommendation_definition, #recommendation_answer_definition, checklist_definition, quetion_definition, element_definition, answer_definition
  #goal_definition, objective_definition, intervention_cluster
  #intervention_definition, interventions
  #intervention_comments, student_comments

  #probe_definitions, recommended_monitors, intervention_probe_assignment, probe, probe_definition_benchmarks


  #checklists, answers, recommendations, recommendation_answers
 
  #principal_overrides
  #(intervention requires school and user), so does probe_definitions
  
  def initialize
    @id_mapping={
      'frequency_id' => Hash[1,529071850,2,680074761,3,284292352,4,939654166,5,344418694] ,
      'time_length_id' => Hash[5, 503752779, 4, 601648301, 2, 782065165, 3, 785548667, 6, 827625344, 1, 858529777]
    }
    @ids_to_map=[]
    @cols_to_map=[]
  end
  def self.district
    @@district ||= District.find_by_state_dpi_num(3269).id
  end


  def import_file table_name
    arr=[]
    headers = nil
    if table_name == "intervention_probe_assignments"
      filename = "intervention_probe_definitions"
    else
      filename = table_name
    end
    e=FasterCSV.foreach "k/#{filename}.csv", {:headers=>true} do |row|
      unless headers
        headers = row.headers
        headers.delete("district_id")
        headers.delete("#{filename.singularize}_id")
        @ids_to_map= headers.select{|h| (h=="from_tier" || h =~ /id$/ ) && table_name.classify.constantize.column_names.include?(h)}
        @ids_to_map << "intervention_probe_assignment_id" if table_name == "probes"
        
        @cols_to_map= (headers - table_name.classify.constantize.column_names)
        @cols_to_map.each{|c| headers.delete(c)}
        map_ids 
      end
      
      vals=headers.inject({}) {|h,k| h[k]=row[k];h}
      vals.merge!(:district_id => ImportMMSD.district) if table_name.classify.constantize.column_names.include?("district_id")
      @ids_to_map.each{|idm| vals.merge!(idm=>@id_mapping[idm][row[idm].to_i])}
      @cols_to_map.each{|col_to_map| vals.merge!(map_column(row,col_to_map, table_name))}
      #      puts vals.inspect
      n=table_name.classify.constantize.new(vals)
      n.type = row["type"] if headers.include?("type")
      unless n.valid?
        next if n.errors.on("student_id")
        if n.errors.on("other") && n.class == Recommendation
          #ignore
        elsif n.errors.on("description") && n.class == ProbeDefinition
          n.description = ""
        elsif n.errors.on("title") && n.class == ProbeDefinition
          #ignore
        elsif n.errors.on("end_date") && n.class == InterventionProbeAssignment
          n.first_date = row["first_date"].to_date
        elsif n.errors.on("action") && n.class == PrincipalOverride
          #ignore
        elsif n.errors.on("benchmark")
          #ignore
        else
          raise n.errors.inspect
        end
      end
      n.send(:create_without_callbacks)
      arr << [row["#{filename.singularize}_id"].to_i, n.id]
    end
    FasterCSV.open("k/map/#{table_name}.csv","w") do |row|
      arr.each {|arr_row| row << arr_row}
    end
    nil
  end



  def map_ids
    @ids_to_map.each do |id_to_map|
      unless @id_mapping[id_to_map]
        if id_to_map == 'student_id'
          @id_mapping[id_to_map]=Hash[*Student.all(:select=>'id,id_district',:conditions=>{:district_id => ImportMMSD.district}).collect{|e| [e.id_district,e.id]}.flatten]
        elsif id_to_map == 'teacher_id'
          @id_mapping[id_to_map]=Hash[*User.all(:select=>'id,id_district',:conditions=>{:district_id => ImportMMSD.district}).collect{|e| [e.id_district,e.id]}.flatten]
        elsif id_to_map == "author_id"
          @id_mapping[id_to_map]=Hash[*User.all(:select=>'id,id_district',:conditions=>{:district_id => ImportMMSD.district}).collect{|e| [e.id_district,e.id]}.flatten]
        elsif id_to_map == "user_id"
          @id_mapping[id_to_map]=Hash[*User.all(:select=>'id,id_district',:conditions=>{:district_id => ImportMMSD.district}).collect{|e| [e.id_district,e.id]}.flatten]
        elsif id_to_map == "principal_id"
          @id_mapping[id_to_map]=Hash[*User.all(:select=>'id,id_district',:conditions=>{:district_id => ImportMMSD.district}).collect{|e| [e.id_district,e.id]}.flatten]

        else
          if id_to_map == "from_tier"
            filename = "tiers"
          else
            filename = id_to_map.sub(/_id$/,'s')
          end
          z=FasterCSV.read("k/map/#{filename}.csv",:converters=>:numeric)
          @id_mapping[id_to_map] = Hash[*z.flatten]
        end
      end
    end
          @ids_to_map.delete("intervention_probe_assignment_id")
  end

  def map_column row,col,tab

    if tab == "principal_overrides"
       return case col
    when "calendar_id"
      {}
    when "request_reason"
      {"teacher_request" => row["request_reason"]} 
    when "accept_reason","rejection_reason"
      {"principal_response" => (row["accept_reason"].to_s + row["rejection_reason"].to_s)}
    when "from_tier"
      unless @id_mapping["tier_id"]
          z=FasterCSV.read("k/map/tiers.csv",:converters=>:numeric)
          @id_mapping["tier_id"] = Hash[*z.flatten]
      end
    
        if row["status"]=="1"
          end_tier = @id_mapping["tier_id"][(1+row["from_tier"].to_i)]
          puts "highest tier???" and end_tier=@id_mapping["tier_id"][row["from_tier"].to_i]  if end_tier.blank?
        end
        puts end_tier
        {"start_tier_id" => @id_mapping["tier_id"][row["from_tier"].to_i], 'end_tier_id' => end_tier}
    else
      raise "#{col}???"
    end
  end
  
    if tab == "intervention_probe_assignments"
      return case col
    when "frequency"
      {}
    when "last_date"
      {"end_date" => row["last_date"].to_date}
    when "disabled"
      {"enabled" => row["disabled"].to_i !=1}
    else
      raise "#{col}???"
    end
  end
    if tab == "probes"

    return case col
    when "date_probe_administered"
        {"administered_at" => row["date_probe_administered"].to_date}
    when "updated_on"
        {"updated_at" => row["updated_on"]}
    when "assessment_type","transaction"
        {}
    when "intervention_probe_definition_id"
        {"intervention_probe_assignment_id" => @id_mapping['intervention_probe_assignment_id'][row["intervention_probe_definition_id"].to_i]}
    else
      raise "#{col}???"
    end
    end



    
    if tab == "probe_definitions"

      return case col
    when "author_id"
        {"user_id" => row["author_id"] ? find_user(row["author_id"]) : nil}
    when "updated_on"
        {"updated_at" => row["updated_on"]}
    when "calendarID"
      {}
    when "my_parent_id"
      {}
    else
      raise "#{col}???"
    end
    end

    if tab == "flags"
      return case col
    when "person_id"
        {'student_id' => row["person_id"] ? find_student(row["person_id"]) : nil}
    when "flagtype"
        {'category' => row["flagtype"] }
      when "teacher_id"
        {"user_id" => row["teacher_id"] ? find_user(row["teacher_id"]) : nil}
      when "severity"
        {}
    else
      raise "#{col}???"
    end
  end


    
    if tab == "recommendations"
      return case col
    when "teacher_id"
      {}
    else
      raise "#{col}???"
    end
  end

    if tab == "interventions"
      return case col
      when "teacher_id"
        {"user_id" => row["teacher_id"] ? find_user(row["teacher_id"]) : nil}
      when "time_length_type"
        {"time_length_id" => row["time_length_type"] ? @id_mapping['time_length_id'][row["time_length_type"].to_i] : nil}
      when "ended_by"
        {"ended_by_id" => row["ended_by"] ? find_user(row["ended_by"]) : nil}
        
      else
        raise "#{col}???"
      end
    end
    if tab == "intervention_definitions"
      return case col
      when "default_option"
        {'custom' => (row["default_option"] !="Y")}
      when *["measurement","grade_level","url"]
        {}
      when "updated_on"
        {"updated_at" => row["updated_on"]}
      when "created_by"
        {"user_id" => row["created_by"] ? find_user(row["created_by"]) : nil}
      when "SchoolName"
        {"school_id" => row["SchoolName"] ? find_school_by_name(row["SchoolName"]) : nil}
      else
        raise "#{col}???"

      end
    end

    if tab == "checklists"
      return case col
      when "teacher_id"
        {"user_id" => row["teacher_id"] ? find_user(row["teacher_id"]) : nil}
      when "calendar_id"
        {}
      else
        raise "#{col}???"

      end
    end
        

    if tab == "student_comments" or tab == "intervention_comments"
      return case col
      when "personID"
        {'student_id' => row["personID"] ? find_student(row["personID"]) : nil}
      when "author_id"
        {"user_id" => row["author_id"] ? find_user(row["author_id"]) : nil}
      when "private"
        {}
        
      else 
        raise "#{col}???"
      end
    end


    
    case col
    when "updated_on"
        {"updated_at" => row["updated_on"]}
    when "rank"
        {"position" => row["rank"]}
    else
      raise "#{col}???"
    end

  end

  def find_user old_id
    @id_mapping['user_id'] ||={}
    @id_mapping['user_id'][old_id] ||= (User.find_by_id_district_and_district_id(old_id,ImportMMSD.district)||User.new).id
  end

  def find_student old_id
    @id_mapping['student_id'] ||={}
    @id_mapping['student_id'][old_id] ||= (Student.find_by_id_district_and_district_id(old_id,ImportMMSD.district)||Student.new).id

  end

  def find_school_by_name name
    @id_mapping['school_name'] ||={}
    name.sub!(/  [0-9][0-9]-[0-9][0-9]$/,'') 
    sch=@id_mapping['school_name'][name] ||= School.find_by_name_and_district_id(name,ImportMMSD.district)
    raise name if sch.blank?
    sch.id
    
  end
end

