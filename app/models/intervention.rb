# == Schema Information
# Schema version: 20090212222347
#
# Table name: interventions
#
#  id                         :integer         not null, primary key
#  user_id                    :integer
#  student_id                 :integer
#  start_date                 :date
#  end_date                   :date
#  intervention_definition_id :integer
#  frequency_id               :integer
#  frequency_multiplier       :integer
#  time_length_id             :integer
#  time_length_number         :integer
#  active                     :boolean         default(TRUE)
#  ended_by_id                :integer
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
  has_many :participant_users, :through => :intervention_participants, :source=>:user

  has_many :intervention_probe_assignments, :dependent=>:destroy 
  validates_numericality_of :time_length_number, :frequency_multiplier
  validates_presence_of :intervention_definition
  validates_associated :intervention_definition, :if => Proc.new {|i| i.intervention_definition && i.intervention_definition.new_record?}
  validate :validate_intervention_probe_assignment
  

  before_create :assign_implementer
  after_create :autoassign_probe,:create_other_students, :send_creation_emails
  after_update :save_assigned_monitor
  

  attr_accessor :selected_ids, :apply_to_all, :auto_implementer, :called_internally, :school_id
  attr_reader :autoassign_message


  named_scope :active,:conditions=>{:active=>true}
  named_scope :inactive,:conditions=>{:active=>false}

 
  def self.build_and_initialize(args)
    #TODO Refactor

    if k=args["intervention_definition"] and !k.is_a?(InterventionDefinition)
      int_def_args = (args.delete("intervention_definition"))
    end
    

    int=self.new(args)
    int.build_intervention_definition(int_def_args) if int_def_args
    

    
    if int.intervention_definition.new_record? 
      #This represents a custom intervention, passing in a new intervention definition as a param
      int.intervention_definition.school_id = int.school_id
      int.intervention_definition.custom = true
      int.intervention_definition.user_id = int.user_id
      int.intervention_definition.time_length = int.time_length
      int.intervention_definition.time_length_num = int.time_length_number
      int.intervention_definition.frequency = int.frequency
      int.intervention_definition.frequency_multiplier = int.frequency_multiplier
    end
            
    int.start_date ||=Time.now
    if int.intervention_definition
      int.frequency ||= int.intervention_definition.frequency
      int.frequency_multiplier ||= int.intervention_definition.frequency_multiplier
      int.time_length ||= int.intervention_definition.time_length
      int.time_length_number ||= int.intervention_definition.time_length_num
    end
    int.time_length ||= TimeLength.first
    
    int.time_length_number ||= 1
    int.end_date ||= (int.start_date + (int.time_length_number*int.time_length.days).days)
    int.selected_ids=nil if int.selected_ids.size == 1
    
    int
  end

  delegate :title, :tier,:description, :intervention_cluster, :to => :intervention_definition
  delegate :objective_definition, :to => :intervention_cluster
  delegate :goal_definition, :to =>:objective_definition

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
    intervention_participants | [intervention_participants.build(:user=>self.user,:role=>InterventionParticipant::AUTHOR)]
  end

  def build_custom_probe(opts={})
    probe_definition = ProbeDefinition.new(opts)
    probe_definition.intervention_definitions << self.intervention_definition
    probe_definition.intervention_probe_assignments.build(:enabled => true, :intervention => self)
    probe_definition
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
    intervention_probe_assignments.update_all(:enabled=>false)
    return if params.blank? or params[:probe_definition_id].blank?
    @ipa=intervention_probe_assignments.find_by_probe_definition_id(params[:probe_definition_id]) || intervention_probe_assignments.build
    @ipa.attributes=params.merge(:enabled=>true)
    @ipa.first_date = Date.civil(params["first_date(1i)"].to_i,params["first_date(2i)"].to_i,params["first_date(3i)"].to_i)
    @ipa.end_date = Date.civil(params["end_date(1i)"].to_i,params["end_date(2i)"].to_i,params["end_date(3i)"].to_i)
  end
  
  def intervention_probe_assignment(probe_definition_id=nil)
    
    if probe_definition_id
      intervention_probe_assignments.find_or_initialize_by_probe_definition_id(probe_definition_id)
    else
      @ipa || intervention_probe_assignments.active.first
    end
  end

  def comment=(txt)
    comments.build(:comment=>txt[:comment], :user_id=>self.user_id) if !txt[:comment].blank?
  end

  def assigned_probes
    intervention_probe_assignments.active.collect(&:title).join(";")
  end

  protected

  def create_other_students
    # TODO tests
    # make sure it does nothing when apply_to_all if false
    # make sure it doesn't create double interventions for the selected student
    # make sure it creates interventions for each student
    if self.apply_to_all == "1"
      student_ids = self.selected_ids
      student_ids.delete(self.student_id.to_s)
      @interventions = student_ids.collect do |student_id|
        Intervention.create!(self.attributes.merge(:student_id => student_id, :apply_to_all => false,
          :auto_implementer => self.auto_implementer, :called_internally => true))
      end
    end
    true
  end

  def assign_implementer
    if self.auto_implementer == "1"
      intervention_participants.implementer.build(:user=>self.user,:skip_email=>true)
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
end
