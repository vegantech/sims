class InterventionParticipant < ActiveRecord::Base
  belongs_to :user
  belongs_to :intervention

  validates_uniqueness_of :user_id, :scope=>:intervention_id, :message=>"has already been assigned to this intervention"


  IMPLEMENTER=0
  PARTICIPANT=1

  named_scope :implementer, :conditions=>{:role=>IMPLEMENTER}

end
