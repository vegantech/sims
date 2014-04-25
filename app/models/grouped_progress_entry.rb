class GroupedProgressEntry
#  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  attr_accessor :global_date, :intervention, :probe_definition

  def errors
    []
  end

  def self.all(user, search)
    student_ids = StudentSearch.search(search).pluck(:student_id)
    interventions2(user.id,student_ids).map { |c| new(c,user,student_ids, search) }
  end

  def self.find(user,param,search)
    all(user,search).detect { |l| l.to_param == param } ||  raise(ActiveRecord::RecordNotFound)
  end

  def initialize(obj,user,student_ids, search = {})
    @intervention = obj
    @probe_definition = @intervention.intervention_probe_assignment.probe_definition
    @user = user
    @student_ids = student_ids
    @school = School.find(search[:school_id])
    @aggregate_chart = AggregateChart.new(
      intervention: @intervention,
      probe_definition: @probe_definition)
  end

  def to_param
    "#{@intervention.intervention_definition_id}-#{@intervention.probe_definition_id}"
  end

  def to_s
    "#{@intervention.title}"
  end

  def id
    self.object_id
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

  def update_interventions(param)
    param.each do |int_id, int_attr|
      student_interventions.each do |i|
        if i.id.to_s == int_id then
          i.update_attributes(int_attr)
        end
      end
    end
  end

  def update_attributes(param)
    participants = param.delete("participant_user_ids") || []
    update_interventions(param)
    if student_interventions.all?(&:valid?)
      save_student_interventions(participants)
      true
    else
      false
    end
  end

  def save_student_interventions(participants)
    student_interventions.each(&:save)
    save_new_participants(participants)
  end

  def save_new_participants(participants)
    User.find_all_by_id(participants).each do |user|
      add_interventions_to_user(user)
    end
  end

  def student_intervention_ids
    student_interventions.collect(&:id)
  end

  def add_interventions_to_user(user)
    new_intervention_participant = student_intervention_ids - user.interventions_as_participant_ids
    user.interventions_as_participant_ids |= new_intervention_participant
    user.save
    Notifications.intervention_participant_added(InterventionParticipant.find_all_by_intervention_id_and_user_id(new_intervention_participant, user.id),Intervention.find_all_by_id(new_intervention_participant)).deliver unless new_intervention_participant.blank?
  end




  def students_with_scores_count
    ipa = InterventionProbeAssignment.find_all_by_probe_definition_id(
      @probe_definition.id,
      include: [:probes,{intervention: :student}], conditions: ["probes.score is not null and interventions.intervention_definition_id = ?",
                                                                @intervention.intervention_definition_id])

        ipa.size
  end

  def page_nums
    (0..((students_with_scores_count.to_f / AggregateChart::NUMBER_OF_STUDENTS_ON_GRAPH).floor))
  end

  def aggregate_chart(page = 0)
    @aggregate_chart.chart_page(page.to_i)
  end

  def persisted?
    true
  end

  private
  def self.interventions(id)
    #TODO TESTS
    Intervention.find(:all,include: :intervention_participants,
                           conditions: ["intervention_participants.user_id = ? or interventions.user_id = ?",id,id])
  end

  def self.interventions2(id, student_ids)
    Intervention.find_all_by_active_and_student_id(true,student_ids,
                      joins: [:intervention_probe_assignments,:intervention_participants,:intervention_definition],
                      conditions: ["(intervention_participants.user_id = ? or interventions.user_id = ?)
      and intervention_probe_assignments.id is not null and intervention_probe_assignments.enabled=true",id,id],
                      group: 'intervention_definition_id,intervention_probe_assignments.probe_definition_id',
                      having: 'count(distinct student_id) > 1',
                      select: 'intervention_definitions.title, interventions.id,
    interventions.intervention_definition_id,probe_definition_id, count(distinct student_id) as student_count'
                     )
  end

  def find_student_interventions
     Intervention.find_all_by_intervention_definition_id_and_active_and_student_id(@intervention.intervention_definition_id, true, @student_ids,
                     include: [:student, :intervention_probe_assignments, :intervention_participants],
                     conditions: ["(intervention_participants.user_id = ? or interventions.user_id = ?)", @user.id, @user.id]
                                                       ).collect{|i| ScoreComment.new(i, @user)}

  end


end


