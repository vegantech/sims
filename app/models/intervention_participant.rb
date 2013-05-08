# == Schema Information
# Schema version: 20101101011500
#
# Table name: intervention_participants
#
#  id              :integer(4)      not null, primary key
#  intervention_id :integer(4)
#  user_id         :integer(4)
#  role            :integer(4)      default(1)
#  created_at      :datetime
#  updated_at      :datetime
#

class InterventionParticipant < ActiveRecord::Base
  belongs_to :user
  belongs_to :intervention, :inverse_of => :intervention_participants

  delegate :email, :fullname, :to => '(user or return nil)'


#  validates_uniqueness_of :user_id, :scope => :intervention_id, :message => "has already been assigned to this intervention"
  validates_presence_of :user_id
  after_create :notify_new_participant, :if => :send_email

  AUTHOR = -1
  IMPLEMENTER = 0
  PARTICIPANT = 1

  ROLES = %w{Implementer Participant Author}
  scope :implementer, where(:role => IMPLEMENTER)
  define_statistic :participants , :count => :all, :joins => :user
  define_statistic :users_as_participant , :count => :all,:column_name => 'distinct user_id', :joins => :user
  attr_accessor :send_email

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
    [RoleStruct.new(IMPLEMENTER, ROLES[IMPLEMENTER]), RoleStruct.new(PARTICIPANT, ROLES[PARTICIPANT])]

  end

  private
  def notify_new_participant
    Notifications.intervention_participant_added(self,intervention).deliver
  end
end
