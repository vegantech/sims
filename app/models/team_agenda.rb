class TeamAgenda < ActiveRecord::Base
  belongs_to :team, :class_name => 'SchoolTeam'
end
