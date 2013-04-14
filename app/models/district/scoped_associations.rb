module District::ScopedAssociations
  def intervention_clusters
    @intervention_clusters ||= InterventionCluster.scoped :joins => {:objective_definition=>:goal_definition},
      :conditions => {:goal_definitions =>{:district_id => self.id}}
  end

  def intervention_definitions
    @intervention_definitions ||= InterventionDefinition.scoped :joins => {:intervention_cluster => {:objective_definition=>:goal_definition}},
      :conditions => {:goal_definitions =>{:district_id => self.id}}
  end

  def question_definitions
    QuestionDefinition.joins(:checklist_definition).merge(ChecklistDefinition.where district_id: self.id)
  end

  def element_definitions
    ElementDefinition.joins(:question_definition => :checklist_definition).merge(ChecklistDefinition.where district_id: self.id)
  end

  def answer_definitions
    AnswerDefinition.joins(:element_definition => {:question_definition => :checklist_definition}).merge(ChecklistDefinition.where district_id: self.id)
  end

  def checklists
    Checklist.joins(:checklist_definition).merge(ChecklistDefinition.where district_id: self.id)
  end

  def answers
    Answer.joins(:checklist => :checklist_definition).merge(ChecklistDefinition.where district_id: self.id)
  end

  def interventions
    Intervention.joins(:intervention_definition => {:intervention_cluster => {:objective_definition => :goal_definition}}).merge(
      GoalDefinition.where district_id: self.id)
  end

  def intervention_probe_assignments
    InterventionProbeAssignment.joins(:intervention => {
      :intervention_definition => {:intervention_cluster => {:objective_definition => :goal_definition}
    }}).merge(
      GoalDefinition.where district_id: self.id)
  end

  def probes
    Probe.joins(:intervention_probe_assignment => {:intervention => {
      :intervention_definition => {:intervention_cluster => {:objective_definition => :goal_definition}
    }}}).merge(
      GoalDefinition.where district_id: self.id)
  end

  def intervention_comments
    InterventionComment.joins(:user).merge(User.where district_id: self.id)
  end

  def student_comments
    StudentComment.joins(:user).merge(User.where district_id: self.id)
  end

  def recommendations
    Recommendation.joins(:user).merge(User.where district_id: self.id)
  end

  def recommendation_definitions
    RecommendationDefinition.scoped
  end

  def recommendation_answer_definitions
    RecommendationAnswerDefinition.joins(:recommendation_definition)
  end

  def frequencies
    Frequency.scoped
  end

  def time_lengths
    TimeLength.scoped
  end

  def recommendation_answers
    RecommendationAnswer.joins(:recommendation => :user).merge(User.where district_id: self.id)
  end

  def probe_definition_benchmarks
    ProbeDefinitionBenchmark.joins(:probe_definition).merge(ProbeDefinition.where district_id: self.id)
  end

  def recommended_monitors
    RecommendedMonitor.joins(:probe_definition).merge(ProbeDefinition.where district_id: self.id)
  end

  def consultation_forms
    ConsultationForm.joins(:team_consultation => {:school_team=>:school}).merge(School.where district_id: self.id)
  end

  def consultation_form_concerns
    ConsultationFormConcern.joins(:consultation_form => {:team_consultation => {:school_team=>:school}}).merge(School.where district_id: self.id)
  end

  def consultation_form_requests
    ConsultationFormRequest.joins(:school_team=>:school).merge(School.where district_id: self.id)
  end

  def custom_flags
    CustomFlag.joins(:user).merge(User.where district_id: self.id)
  end

  def ignore_flags
    IgnoreFlag.joins(:user).merge(User.where district_id: self.id)
  end

  def news_items
    news
  end

  def principal_overrides
    PrincipalOverride.joins(:teacher).merge(User.where district_id: self.id)
  end

  def school_team_memberships
    SchoolTeamMembership.joins(:school_team => :school).merge(School.where district_id: self.id)
  end

  def team_consultations
    TeamConsultation.joins(:school_team => :school).merge(School.where district_id: self.id)
  end

  #If I have defined a district scope in that class, then I can use that to preserve encapsulation
  def method_missing(method_name,*args,&block)
    if klass=get_class_for_method_missing(method_name)
      klass.send(:district).merge(District.where id: self.id)
    else
      super
    end
  end

  def get_class_for_method_missing(method_name)
    begin
      klass = method_name.to_s.classify.constantize
      return klass if klass.respond_to?:district
    rescue NameError
    end
  end



end
