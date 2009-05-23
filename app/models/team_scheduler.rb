class TeamScheduler < ActiveRecord::Base
  belongs_to :user
  belongs_to :school

  def to_s
      "#{user if user}"
  end

end
