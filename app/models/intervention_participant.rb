# == Schema Information
# Schema version: 20090212222347
#
# Table name: intervention_participants
#
#  id              :integer         not null, primary key
#  intervention_id :integer
#  user_id         :integer
#  role            :integer         default(1)
#  created_at      :datetime
#  updated_at      :datetime
#

class InterventionParticipant < ActiveRecord::Base
  belongs_to :user
  belongs_to :intervention

  delegate :email,:fullname, :to=>:user
  attr_writer :skip_email

  after_create :send_new_participant_email
  
  validates_uniqueness_of :user_id, :scope => :intervention_id, :message => "has already been assigned to this intervention"
  validates_presence_of :user_id, :role, :intervention_id

  AUTHOR=-1
  IMPLEMENTER=0
  PARTICIPANT=1

  ROLES=%w{Implementer Participant Author}
  named_scope :implementer, :conditions=>{:role=>IMPLEMENTER}

  RoleStruct = Struct.new(:id, :name)

  def role_title
    ROLES[role] 
  end

  def toggle_role!
    if self.role == IMPLEMENTER
      self.role = PARTICIPANT
    else
      self.role = IMPLEMENTER
    end
    save!

  end

  def self.roles
    [
    RoleStruct.new(IMPLEMENTER,ROLES[IMPLEMENTER]),
    RoleStruct.new(PARTICIPANT,ROLES[PARTICIPANT])
    ]
    
  end

  protected
 
  def send_new_participant_email
    unless @skip_email
      Notifications.deliver_intervention_participant_added(self)
    end
  end

end
