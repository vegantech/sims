class DailyJobs
  def self.run
    CreateTrainingDistrict.generate  if  Rails.env.veg_open?
  end

  def self.run_weekly
    Notifications.setup_ending_reminders() # run for all districts
  end
end
