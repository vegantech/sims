class InterventionParticipant < ActiveRecord::Base
  belongs_to :user
  belongs_to :intervention

  delegate :email,:fullname, :to=>:user

  validates_uniqueness_of :user_id, :scope=>:intervention_id, :message=>"has already been assigned to this intervention"

  AUTHOR=-1
  IMPLEMENTER=0
  PARTICIPANT=1

  ROLES=%w{Implementer Participant Author}
  named_scope :implementer, :conditions=>{:role=>IMPLEMENTER}

  def role_title
    ROLES[role] 
  end

end
