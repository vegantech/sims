# == Schema Information
# Schema version: 20090524185436
#
# Table name: team_schedulers
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  school_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class TeamScheduler < ActiveRecord::Base
  belongs_to :user
  belongs_to :school

  def to_s
      "#{user if user}"
  end

end
