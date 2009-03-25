# == Schema Information
# Schema version: 20090325230037
#
# Table name: intervention_comments
#
#  id              :integer         not null, primary key
#  intervention_id :integer
#  comment         :text
#  user_id         :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class InterventionComment < ActiveRecord::Base
  belongs_to :user
  belongs_to :intervention
  validates_presence_of :comment
end
