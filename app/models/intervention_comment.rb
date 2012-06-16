# == Schema Information
# Schema version: 20101101011500
#
# Table name: intervention_comments
#
#  id              :integer(4)      not null, primary key
#  intervention_id :integer(4)
#  comment         :text
#  user_id         :integer(4)
#  created_at      :datetime
#  updated_at      :datetime
#

class InterventionComment < ActiveRecord::Base
  belongs_to :user
  belongs_to :intervention, :inverse_of => :comments
  validates_presence_of :comment

  before_validation :get_user_from_intervention, :if => :intervention
  before_validation :verify_user, :on => :update

  def to_s
    "#{comment} by #{user} on #{updated_at.to_date}"
  end

  private

  def get_user_from_intervention
    self.user_id = intervention.comment_author
  end

  def verify_user
    if user_id_changed?
      self.comment=comment_was
      self.user_id = user_id_was
      self.intervention_id = intervention_id_was
    end
    return true
  end

end
