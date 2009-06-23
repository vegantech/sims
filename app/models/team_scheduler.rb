# == Schema Information
# Schema version: 20090623023153
#
# Table name: team_schedulers
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  school_id  :integer(4)
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
