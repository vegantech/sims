class SchoolTeamMembership < ActiveRecord::Base
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
