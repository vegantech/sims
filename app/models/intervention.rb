# == Schema Information
# Schema version: 20101101011500
#
# Table name: interventions
#
#  id                         :integer(4)      not null, primary key
#  user_id                    :integer(4)
#  student_id                 :integer(4)
#  start_date                 :date
#  end_date                   :date
#  intervention_definition_id :integer(4)
#  frequency_id               :integer(4)
#  frequency_multiplier       :integer(4)
#  time_length_id             :integer(4)
#  time_length_number         :integer(4)
#  active                     :boolean(1)      default(TRUE)
#  ended_by_id                :integer(4)
#  ended_at                   :date
#  created_at                 :datetime
#  updated_at                 :datetime
#  end_reason                 :string(255)
#

class Intervention < ActiveRecord::Base
  DISTRICT_PARENT = :intervention_definition
  include LinkAndAttachmentAssets
  include ActionView::Helpers::TextHelper

  END_REASONS = [
    "Sufficient progress made",
    "Insufficient progress made",
    "Beyond intervention interval",
    "Intervention not matched to student need"
  ]

  UNATTACHED_DESCRIPTION="An unattached intervention is an
  intervention that has not yet been ended
  that has also gone past the end date,
    has one or more participants that cannot access the student,
    or has no participants at all."

  belongs_to :user
  belongs_to :student, :touch => true
  belongs_to :intervention_definition
  belongs_to :frequency
  belongs_to :time_length
  belongs_to :ended_by, :class_name => "User"
  has_many :comments, :class_name => "InterventionComment", :dependent => :destroy, :order => "updated_at DESC", :inverse_of => :intervention, :include => :user
  has_many :intervention_participants, :dependent => :delete_all, :before_add => :notify_new_participant, :inverse_of => :intervention
  has_many :participant_users, :through => :intervention_participants, :source => :user
  has_many :intervention_probe_assignments, :dependent => :destroy
  validates_numericality_of :time_length_number, :frequency_multiplier
  validates_presence_of :intervention_definition, :start_date, :end_date
  #validates_associated :intervention_probe_assignments
  validate :validate_intervention_probe_assignment, :end_date_after_start_date?
  accepts_nested_attributes_for :intervention_definition, :reject_if =>proc{|e| false}
  accepts_nested_attributes_for :comments, :reject_if =>proc{|e| e["comment"].blank?}

  after_initialize :set_defaults_from_definition
  before_create :assign_implementer
  after_create :autoassign_probe, :create_other_students, :send_creation_emails
  after_save :save_assigned_monitor

  attr_accessor :selected_ids, :apply_to_all, :auto_implementer, :called_internally, :school_id, :creation_email, :comment_author
  attr_reader :autoassign_message



  delegate :title, :tier, :description, :intervention_cluster,:tier_summary, :to => :intervention_definition
  delegate :objective_definition, :to => :intervention_cluster
  delegate :goal_definition, :to => :objective_definition
  scope :desc, order("created_at desc")
  scope :active, where(:active => true).desc
  scope :inactive, where(:active => false).desc
  scope :for_report

  scope :author_or_participant, lambda { |user_id|
    includes([:intervention_participants, :user,:frequency, :time_length, :intervention_definition]).where(
      ["interventions.user_id = :user_id or intervention_participants.user_id = :user_id", {:user_id => user_id}])
  }



  define_statistic :interventions , :count => :all, :joins => :student
  define_statistic :students_with_interventions , :count => :all,  :column_name => 'distinct student_id', :joins => :student
  define_statistic :districts_with_interventions, :count => :all, :column_name => 'distinct district_id', :joins => {:intervention_definition => {:intervention_cluster => {:objective_definition => :goal_definition}}}
  define_statistic :users_with_interventions, :count => :all, :column_name => 'distinct user_id', :joins => :user

  def self.build_and_initialize(args)
    # TODO Refactor

    # if k = args["intervention_definition"] and !k.is_a?(InterventionDefinition)
    #  int_def_args = (args.delete("intervention_definition"))
    #end

    int = self.new(args)
    int.intervention_definition.set_values_from_intervention(int) if int.intervention_definition && int.intervention_definition.new_record?
    int.auto_implementer=true if int.auto_implementer.nil?

    int.selected_ids = nil if Array(int.selected_ids).size == 1

    int
  end

  def self.for_user_interventions_report(user_id, filter,start_date = 5.years.ago,end_date = Date.today)
    ints = author_or_participant(user_id).where(:updated_at => start_date..(end_date+2))
    if filter == "Current"
      ints = ints.where(["active = ?",true])
    elsif filter == "Ended"
      ints = ints.where(["active = ?",false])
    end
    ints
  end


  def end(ended_by,reason='', fidelity = nil)
    self.ended_by_id = ended_by
    self.active = false
    self.ended_at = Date.today
    self.end_reason=reason
    self.fidelity = fidelity
    self.save!
  end

  def undo_end
    self.ended_by_id = nil
    self.active = true
    self.ended_at = nil
    self.end_reason=nil
    self.fidelity=nil
    self.save!
  end

  def participants_with_author
    intervention_participants | [intervention_participants.build(:user => self.user,:role => InterventionParticipant::AUTHOR).destroy]
  end

  def auto_implementer?
    @auto_implementer == "1"
  end

  def frequency_summary
    "#{pluralize frequency_multiplier, "time"} #{frequency.title}"
  end

  def time_length_summary
    pluralize time_length_number, time_length.title
  end

  def intervention_probe_assignment=(params)
    intervention_probe_assignments.update_all(:enabled => false) #disable all others
    params.stringify_keys! unless params.blank? #fix for LH #392
    return if params.blank? or (params['probe_definition_id']=='' and params['probe_definition_attributes'].blank? )

    if params['probe_definition_id'] == 'custom'
      params['probe_definition_id'] = nil
    end
    @ipa = intervention_probe_assignments.find_by_probe_definition_id(params['probe_definition_id']) || intervention_probe_assignments.build
    @ipa.attributes = params.merge(:enabled => true)
  end

  def intervention_probe_assignment(probe_definition_id = nil)
    if probe_definition_id
      intervention_probe_assignments.find_or_initialize_by_probe_definition_id(probe_definition_id)
    else
      p=@ipa || intervention_probe_assignments.active.first
      p.build_probe_definition if p && p.probe_definition.blank?
      p
    end
  end

  def assigned_probes
    intervention_probe_assignments.active.collect(&:title).join(";")
  end

  def report_summary
    "#{title} #{'Ended: ' + ended_at.to_s(:chatty) unless active?}"
  end

  def set_missing_values_from_intervention_definition
    if intervention_definition
      self.frequency ||= intervention_definition.frequency
      self.frequency_multiplier ||= intervention_definition.frequency_multiplier
      self.time_length ||= intervention_definition.time_length
      self.time_length_number ||= intervention_definition.time_length_num
    end
  end

  def date_user_student_school_grade
    arr=[created_at.to_date, user.to_s]
    if student.present?
      arr += [student.to_s]
      if student.enrollments.present?
        arr += [student.enrollments.first.grade, student.enrollments.first.school.to_s]
      else
        arr += [nil,nil]
      end
    else
      arr +=["No longer in sims",nil, nil]
    end

    arr

  end

  def orphaned?
    active? &&
      (end_date < Date.today ||
       participant_users.blank? ||
       !participant_users.all?{|ipu| student.belongs_to_user? ipu}
      )

  end

  def self.orphaned
    #an orphaned intervention is one that is unended past the expected end date or one where no participants can access the student  (be sure to check district_id of student as well)
    find(:all).select(&:orphaned?)
  end

  def goal_objective_category
    [goal_definition.title, objective_definition.title, intervention_cluster.title].join(" ")
  end


  def participant_user_ids=(ids)
    #remove duplicates and blanks
    ids=ids.reject(&:blank?).uniq
    self.participant_users=User.where(:id =>(ids))
  end


  def assets_for_user u
    assets.for_user(u)
  end

  def show_asset_info?
    true
  end

  protected

  def create_other_students
    # TODO tests
    # make sure it does nothing when apply_to_all if false
    # make sure it doesn't create double interventions for the selected student
    # make sure it creates interventions for each student
    if self.apply_to_all == "1"
      comment = {:comment => comments.present? ? comments.first.comment : nil}
      student_ids = Array(self.selected_ids)
      student_ids.delete(self.student_id.to_s)
      ipa = @ipa.try(:attributes)
      @interventions = student_ids.collect do |student_id|
        Intervention.create!(self.attributes.merge(:student_id => student_id, :apply_to_all => false, :comment_author => self.comment_author,
          :auto_implementer => self.auto_implementer, :called_internally => true, :participant_user_ids => self.participant_user_ids,
                                                  :comments_attributes => {"0" => comment} ,:intervention_probe_assignment => ipa))
      end
    end
    true
  end

  def assign_implementer
    @creation_email = true if new_record?  #used for distingushing between new particioant and creation email
    if self.auto_implementer == "1"
      self.participant_user_ids |= [self.user_id]
      # intervention_participants.build(:user => self.user, :skip_email => true, :role => InterventionParticipant::IMPLEMENTER) unless participant_user_ids.include?(self.user_id)
    end
    true
  end

  def autoassign_probe
    rec_mon_count = intervention_definition.probe_definitions.count
    return true if intervention_probe_assignments.any?
    case rec_mon_count
    when 0
      @autoassign_message = 'No Monitors Available for this intervention.'
    when 1
      p=intervention_probe_assignments.active.create!(:probe_definition_id=>intervention_definition.recommended_monitors.first.probe_definition_id,:end_date=>self.end_date,:first_date=>self.start_date, :enabled=>true)
      @autoassign_message = "#{p.title} has been automatically assigned."
    else
      @autoassign_message = 'Please assign a progress monitor.'
    end
    true
  end

  def save_assigned_monitor
    return true unless defined?(@ipa)
    if @ipa.probe_definition.intervention_definitions.blank?
      pd=@ipa.probe_definition
      pd.intervention_definitions << self.intervention_definition
      pd.user_id = user_id
      pd.school_id = school_id
      pd.district_id = goal_definition.district_id
      pd.custom = true

    end
    @ipa.save

  end

  def send_creation_emails
    # PENDING
    @interventions = Array(self) | Array(@interventions)
     unless self.called_internally
      Notifications.intervention_starting(@interventions).deliver
    end

    true
  end

  def validate_intervention_probe_assignment
    return true unless defined? @ipa
    return true if @ipa.valid?
    errors.add(:base,"Progress Monitor Assignment is invalid")
    false
  end


  def end_date_after_start_date?
    errors.add(:end_date, "Must be after start date") and return false if end_date.blank? || start_date.blank? || end_date < start_date
    true
  end

  def default_end_date
   if time_length_number and time_length
      (start_date + (time_length_number*time_length.days).days)
   else
      start_date
   end
  end

  def set_defaults_from_definition
    return unless new_record?
    self.start_date ||= Date.today

    if intervention_definition.blank? || intervention_definition.new_record?
      self.frequency ||= Frequency.find_by_title('Weekly')
      self.frequency_multiplier ||= 2
      self.time_length_number ||= 4
      self.time_length ||= TimeLength.find_by_title('Week')
      #  intervention_definition.set_values_from_intervention(self) if intervention_definition
    else
      set_missing_values_from_intervention_definition
    end

    self.end_date ||= default_end_date
  end

  def notify_new_participant(participant)
    participant.send_email = true unless new_record? or @creation_email or called_internally
  end

end
