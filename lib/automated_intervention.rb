class AutomatedIntervention

  FORMAT="district_student_id,intervention_definition_id,start_date,end_date,probe_definition_id,score,comment"

  def initialize file,user
    @count=0
    @messages = []
    @file = file.path if file
    @user = user
    @district=@user.district

  end

  def import
    process_file
    messages
  end

  def messages
    @messages
  end

  

  private
  def process_file
    @messages << "Processing file"
    check_headers or return false
    lines = FasterCSV.read(@file, ImportCSV::DEFAULT_CSV_OPTS)
    lines.each do |line|
      next  if line[0] =~  /^-+|\(\d+ rows affected\)$/   
        process_row line
    end

    @messages << "#{@count} interventions added"

  end

  def check_headers
    `head -n 1 #{@file}`.strip == FORMAT or 
        (@messages << "Invalid headers: They must be #{FORMAT}" and return false)
  end

  def process_row line
    student= check_student(line[:district_student_id]) or return false
    int_def=check_intervention_definition(line[:intervention_definition_id]) or return false

    intervention=int_def.interventions.build(:student => student, :user => @user, :start_date => line[:start_date], 
                                             :end_date => line[:end_date],
                                             :called_internally=>true)

                                             

    unless intervention.send(:end_date_after_start_date?)
      @messages << "#{intervention.errors.full_messages.to_s} #{line.to_s}" and return false
    end
    
    if line[:end_date].any?
      intervention.active=false
      intervention.ended_by_id = @user.id
    end

    if line[:probe_definition_id].any?
      pd = @district.probe_definitions.find_by_id(line[:probe_definition_id]) 
      pd or 
      (@messages << "Invalid Probe Definition ID #{line.to_s}" and return false)

      intervention.intervention_probe_assignment={:probe_definition_id => line[:probe_definition_id], 
        :first_date => line[:start_date], :end_date => line[:start_date]}

      if line[:score].any?
        probe=intervention.intervention_probe_assignment.probes.build(:score => line[:score], :administered_at => line[:start_date])
        max = pd.maximum_score || (1.0/0) #infinity
        min = pd.minimum_score || (-1.0/0) #-infinity

        unless probe.score.between?(max,min)
          @messages << "Score is not between #{min} and #{max} #{line.to_s}" and return false
        end
      end

    end




    check_for_duplicate(intervention,line) and return false
    intervention.comments.build(:user => @user, :comment => line[:comment]) unless line[:comment].blank?
    intervention.save!
    @count +=1

  end

  def check_student(id)
    @district.students.find_by_district_student_id(id) or
      (@messages << "Unknown student with district_student_id #{id}" and return false)
  end

  def check_intervention_definition int_def_id

    id= InterventionDefinition.find_by_id(int_def_id,:joins => 
                                 {:intervention_cluster => {:objective_definition => :goal_definition}}, 
                                   :conditions => {"goal_definitions.district_id" => @district.id}) 

    if id
      return id
    else
      @messages << "Invalid Intervention Definition ID #{int_def_id}" 
      return false
    end
  end

  def check_for_duplicate i,line
    i.student.interventions.find_by_intervention_definition_id_and_user_id_and_start_date(i.intervention_definition_id,i.user_id,i.start_date) and
    @messages << "Duplicate entry for #{line.to_s}"
  end

  

end
