# == Schema Information
# Schema version: 20081205205925
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

  validates_uniqueness_of :user_id, :scope=>:intervention_id, :message=>"has already been assigned to this intervention"

  AUTHOR=-1
  IMPLEMENTER=0
  PARTICIPANT=1

  ROLES=%w{Implementer Participant Author}
  named_scope :implementer, :conditions=>{:role=>IMPLEMENTER}

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

end
