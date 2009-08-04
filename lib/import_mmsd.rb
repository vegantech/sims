class ImportMMSD
  


  #1. do ic import

  #tier
  #recommendation_definition, #recommendation_answer_definition, checklist_definition, quetion_definition, element_definition, answer_definition
  #goal_definition, objective_definition, intervention_cluster
  
  
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
    e=FasterCSV.foreach "k/#{table_name}.csv", {:headers=>true} do |row|
      unless headers
        headers = row.headers
        headers.delete("district_id")
        headers.delete("#{table_name.singularize}_id")
        @ids_to_map= headers.select{|h| h =~ /id$/}
        @cols_to_map= (headers - table_name.classify.constantize.column_names)
        @cols_to_map.each{|c| headers.delete(c)}
        map_ids 
      end
      
      vals=headers.inject({}) {|h,k| h[k]=row[k];h}
      vals.merge!(:district_id => ImportMMSD.district) if table_name.classify.constantize.column_names.include?("district_id")
      @ids_to_map.each{|idm| vals.merge!(idm=>@id_mapping[idm][row[idm].to_i])}
      @cols_to_map.each{|col_to_map| vals.merge!(map_column(row,col_to_map, table_name))}
      n=table_name.classify.constantize.create!(vals)
      arr << [row["#{table_name.singularize}_id"].to_i, n.id]
    end
    FasterCSV.open("k/map/#{table_name}.csv","w") do |row|
      arr.each {|arr_row| row << arr_row}
    end
    nil
  end



  def map_ids
    @ids_to_map.each do |id_to_map|
      unless @id_mapping[id_to_map]
        z=FasterCSV.read("k/map/#{id_to_map.sub(/_id$/,'')}s.csv",:converters=>:numeric)
        @id_mapping[id_to_map] = Hash[*z.flatten]
      end
    end
  end

  def map_column row,col,tab

     ["default_option", "measurement", "created_by", "SchoolName", "grade_level", "url", "updated_on"]
    if tab == "intervention_definitions"
      return case col
      when "default_option"
        {'custom' => (row["default_option"]=="Y")}
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
    @id_mapping['user_id'][old_id] ||= User.find_by_id_district_and_district_id(old_id,@@district).id
  end

  def find_school_by_name name
    @id_mapping['school_name'] ||={}
    
    sch=@id_mapping['school_name'][name] ||= School.find_by_name_and_district_id(name,@@district)
    raise name if sch.blank?
    sch.id
    
  end
end

