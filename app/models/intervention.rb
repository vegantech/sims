# == Schema Information
# Schema version: 20090623023153
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
#

class Intervention < ActiveRecord::Base
  include LinkAndAttachmentAssets
  include ActionView::Helpers::TextHelper

  belongs_to :user
  belongs_to :student
  belongs_to :intervention_definition
  belongs_to :frequency
  belongs_to :time_length
  belongs_to :ended_by, :class_name => "User"
  has_many :comments, :class_name => "InterventionComment", :dependent => :destroy, :order => "updated_at DESC"
  has_many :intervention_participants, :dependent => :destroy
  has_many :participant_users, :through => :intervention_participants, :source => :user

  has_many :intervention_probe_assignments, :dependent => :destroy 
  validates_numericality_of :time_length_number, :frequency_multiplier
  validates_presence_of :intervention_definition, :start_date, :end_date
  validates_associated :intervention_definition, :if => Proc.new {|i| i.intervention_definition && i.intervention_definition.new_record?}
  #validates_associated :intervention_probe_assignments
  validate :validate_intervention_probe_assignment, :end_date_after_start_date?
  accepts_nested_attributes_for :intervention_definition, :reject_if =>proc{|e| false}
  

  before_create :assign_implementer
  after_create :autoassign_probe, :create_other_students, :send_creation_emails
  after_save :save_assigned_monitor

  attr_accessor :selected_ids, :apply_to_all, :auto_implementer, :called_internally, :school_id, :creation_email, :comment_author
  attr_reader :autoassign_message


  delegate :title, :tier, :description, :intervention_cluster, :to => :intervention_definition
  delegate :objective_definition, :to => :intervention_cluster
  delegate :goal_definition, :to => :objective_definition
  named_scope :active, :conditions => {:active => true}, :order => 'created_at desc'
  named_scope :inactive, :conditions => {:active => false}, :order => 'created_at desc'

  acts_as_reportable # if defined? Ruport

  def self.build_and_initialize(args)
    # TODO Refactor

    # if k = args["intervention_definition"] and !k.is_a?(InterventionDefinition)
    #  int_def_args = (args.delete("intervention_definition"))
    #end

    int = self.new(args)
    int.intervention_definition.set_values_from_intervention(int) if int.intervention_definition && int.intervention_definition.new_record?

    int.selected_ids = nil if int.selected_ids.to_a.size == 1

    int
  end


  def end(ended_by)
    self.ended_by_id = ended_by
    self.active = false
    self.ended_at = Date.today
    self.save!
  end

  def undo_end
    self.ended_by_id = nil
    self.active = true
    self.ended_at = nil
    self.save!
  end

  def participants_with_author
    intervention_participants | [intervention_participants.build(:user => self.user,:role => InterventionParticipant::AUTHOR)]
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

  def comment=(txt)
    @comment=comments.build(:comment=>txt[:comment], :user_id=>comment_author || self.user_id) if !txt[:comment].blank?
  end
  def comment
    @comment
  end

  def assigned_probes
    intervention_probe_assignments.active.collect(&:title).join(";")
  end

  def report_summary
    "#{title} #{'Ended: ' + ended_at.to_s(:chatty) unless active}"
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


  
  protected

  def create_other_students
    # TODO tests
    # make sure it does nothing when apply_to_all if false
    # make sure it doesn't create double interventions for the selected student
    # make sure it creates interventions for each student
    if self.apply_to_all == "1"
      comment = {:comment => comments.present? ? comments.first.comment : nil}
      student_ids = self.selected_ids
      student_ids.delete(self.student_id.to_s)
      ipa = @ipa.try(:attributes)
      @interventions = student_ids.collect do |student_id|
        Intervention.create!(self.attributes.merge(:student_id => student_id, :apply_to_all => false,
          :auto_implementer => self.auto_implementer, :called_internally => true, :participant_user_ids => self.participant_user_ids,
                                                  :comment => comment ,:intervention_probe_assignment => ipa))
      end
    end
    true
  end

  def assign_implementer
    @creation_email = true
    if self.auto_implementer == "1"
      self.participant_user_ids |= [self.user_id]
      # intervention_participants.build(:user => self.user, :skip_email => true, :role => InterventionParticipant::IMPLEMENTER) unless participant_user_ids.include?(self.user_id)
    end
    true
  end

  def autoassign_probe
    rec_mon_count = intervention_definition.recommended_monitors.count
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
    @ipa.probe_definition.intervention_definitions << self.intervention_definition  if @ipa.probe_definition.intervention_definitions.blank?
    @ipa.save

  end

  def send_creation_emails
    # PENDING
    @interventions = Array(self) | Array(@interventions)
    unless self.called_internally 
      Notifications.deliver_intervention_starting(@interventions)
    end

    true
  end
  
  def validate_intervention_probe_assignment
    return true unless defined? @ipa
    return true if @ipa.valid?
    errors.add_to_base("Progress Monitor Assignment is invalid") 
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

  def after_initialize
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
  
end
