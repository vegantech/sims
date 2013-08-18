# == Schema Information
# Schema version: 20101101011500
#
# Table name: school_team_memberships
#
#  id             :integer(4)      not null, primary key
#  school_team_id :integer(4)
#  user_id        :integer(4)
#  contact        :boolean(1)
#  created_at     :datetime
#  updated_at     :datetime
#

class SchoolTeamMembership < ActiveRecord::Base
  DISTRICT_PARENT = :school_team
  belongs_to :school_team
  belongs_to :user

  def to_s
    if contact?
      "<b>#{user}</b>"

    else
      user
    end
  end
end
