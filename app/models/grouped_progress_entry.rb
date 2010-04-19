class GroupedProgressEntry 
  attr_accessor :global_date, :intervention, :probe_definition

  def errors
    []
  end
  def self.all(user, search)
    student_ids=Enrollment.search(search).collect(&:student_id)
    interventions2(user.id,student_ids).map { |c| new(c,user,student_ids, search) }
  end

  def self.find(user,param,search)
    all(user,search).detect { |l| l.to_param == param } || raise(ActiveRecord::RecordNotFound)
  end

  def initialize(obj,user,student_ids, search={})
    @intervention = obj
    @probe_definition = @intervention.intervention_probe_assignment.probe_definition
    @user=user
    @student_ids =student_ids
    @school = School.find(search[:school_id])
  end
  
  def to_param
    "#{@intervention.id}-#{@intervention.probe_definition_id}"
  end

  def to_s
    "#{@intervention.title}"
  end

  def staff
     [nil] | @school.assigned_users.collect{|e| [e.fullname, e.id]}
  end

  def student_count
    "(#{@intervention.student_count})"

  end

  def student_interventions
    @student_interventions ||= find_student_interventions
  end

  def student_interventions=(param)
    raise param.inspect
  end

  def update_attributes(param)
    participants = param.delete("participant_user_ids") || []
    param.each do |int_id, int_attr|
      student_interventions.each do |i|
        if i.id.to_s == int_id then
          int_attr["new_intervention_participant_ids"]= participants.compact.collect(&:to_i).reject(&:zero?)
          i.update_attributes(int_attr)
        end
      end
    end
    if student_interventions.all?(&:valid?)
      student_interventions.each(&:save) 
      true
    else
      false
    end

  end

  class ScoreComment
    attr_accessor :date,:score,:comment,:intervention,:id,:numerator,:denominator
    def initialize(intervention,user)
      @intervention = intervention
      @id = intervention.id
      @user = user
      @comment = ''
      @errors =''
      @probe = nil
      @score = nil
    end

    def errors
      @errors.to_s
    end

    def update_attributes(params)
      @comment = params['comment']
      @intervention.comment_author=@user.id
      @intervention.comment = {:comment => @comment}
      @intervention.participant_user_ids |= params['new_intervention_participant_ids']
      begin
        @date = Date.civil(params["date(1i)"].to_i,params["date(2i)"].to_i,params["date(3i)"].to_i)
      rescue ArgumentError
        @errors +='Invalid Date'
      end
      @score = params[:score]


      @probe=@intervention.intervention_probe_assignment.probes.build(:score => @score) unless @score.blank?
    end

    def valid?
      if @intervention.valid? && (!@probe || @probe.valid?)  && @errors.blank? 
        true
      else
        @errors += @intervention.errors.full_messages.join(", ") +' ' + @probe.errors.full_messages.join(", ")
        false
      end
    end

    def save
      @intervention.save! 
      @probe.save! unless @probe.blank?
    end
    
    def student
      @intervention.student
    end
    def to_param
      @id
    end
  end

private
  def self.interventions(id)
    #TODO TESTS
    Intervention.find(:all,:include => :intervention_participants, :conditions => ["intervention_participants.user_id = ? or interventions.user_id = ?",id,id])
  end

  def self.interventions2(id, student_ids)
    Intervention.find_all_by_active_and_student_id(true,student_ids,
                      :joins => [:intervention_probe_assignments,:intervention_participants,:intervention_definition], 
    :conditions => ["(intervention_participants.user_id = ? or interventions.user_id = ?)  and intervention_probe_assignments.id is not null",id,id],
    :group=>'intervention_definition_id,intervention_probe_assignments.probe_definition_id', 
    :having => 'count(distinct student_id) > 1', 
    :select => 'intervention_definitions.title, interventions.id, interventions.intervention_definition_id,probe_definition_id, count(distinct student_id) as student_count'
                     )
  end

  def find_student_interventions
     Intervention.find_all_by_intervention_definition_id_and_active_and_student_id(@intervention.intervention_definition_id, true, @student_ids,
                     :include => [:student, :intervention_probe_assignments, :intervention_participants],
                     :conditions => ["(intervention_participants.user_id = ? or interventions.user_id = ?)", @user.id, @user.id]
                                                       ).collect{|i| ScoreComment.new(i, @user)}

  end


end


