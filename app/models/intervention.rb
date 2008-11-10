# == Schema Information
# Schema version: 20081030035908
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
  belongs_to :user
  belongs_to :student
  belongs_to :intervention_definition
  belongs_to :frequency
  belongs_to :time_length
  belongs_to :ended_by, :class_name =>"User"
  has_many :intervention_participants

  has_many :intervention_probe_assignments do 
    def prepare_all(passed_params={})
      ipas=find(:all)
      prepared=[]
      proxy_owner.intervention_definition.recommended_monitors.each do |rec_mon|
        if d=ipas.detect{|ipa| ipa.probe_definition_id== rec_mon.probe_definition_id}
        else
          d= proxy_owner.intervention_probe_assignments.build(:probe_definition_id=>rec_mon.probe_definition_id)
        end
      
        if passed_params.respond_to?(:values)
          #TODO look into possible issue where some are new and some aren't
          params=passed_params.values
        else
          params=passed_params
        end
        if p=params.detect{|param_ipa|  !param_ipa.nil? and
          d.probe_definition_id == param_ipa["probe_definition_id"].to_i}
          d.attributes=p
          d.enabled=p[:enabled]
        end
        prepared << d
      end
      prepared
    end
  end

  validates_numericality_of :time_length_number, :frequency_multiplier
  

  before_create :assign_implementer
  after_create :create_other_students, :send_creation_emails

  attr_accessor :selected_ids, :apply_to_all, :auto_implementer, :called_internally


  named_scope :active,:conditions=>{:active=>true}
  named_scope :inactive,:conditions=>{:active=>false}
  
  def self.build_and_initialize(*args)
    int=self.new(*args)
    int.start_date ||=Time.now
    if int.intervention_definition
      int.frequency ||= int.intervention_definition.frequency
      int.frequency_multiplier ||= int.intervention_definition.frequency_multiplier
      int.time_length ||= int.intervention_definition.time_length
      int.time_length_number ||= int.intervention_definition.time_length_num
    end
    int.time_length ||=TimeLength::TIMELENGTHS.first
    int.time_length_number ||= 1
    int.end_date ||= (int.start_date + (int.time_length_number*int.time_length.days).days)
    int.selected_ids=nil if int.selected_ids.size == 1
    
    int
  end

  delegate :title, :intervention_cluster, :to => :intervention_definition
  delegate :objective_definition, :to => :intervention_cluster
  delegate :goal_definition, :to =>:objective_definition



  def end(ended_by)
    self.ended_by_id=ended_by
    self.active=false
    self.ended_at=Date.today
    self.save!
  end



  protected
  def create_other_students
    #TODO tests
    #make sure it does nothing when apply_to_all if false
    #make sure it doesn't create double interventions for the selected student
    #make sure it creates interventions for each student
    if self.apply_to_all =="1"
      student_ids=self.selected_ids
      student_ids.delete(self.student_id.to_s)
      student_ids.each do |student_id|
        Intervention.create!(self.attributes.merge(:student_id=>student_id,:apply_to_all=>false,:auto_implementer=>self.auto_implementer,:called_internallt=>true))
      end
    end
    true

  end

  def assign_implementer
    if self.auto_implementer == "1"
      intervention_participants.implementer.build(:user=>self.user)
    end
    true
  end

  def send_creation_emails
    #PENDING
    unless self.called_internally
    end

    true

  end





end
