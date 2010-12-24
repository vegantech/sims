class DailyJobs
  def self.run
    CreateTrainingDistrict.generate  if  defined?(SIMS_DOMAIN) && SIMS_DOMAIN == "sims-open.vegantech.com"
    self.regenerate_intervention_reports

  end

  def self.regenerate_intervention_reports
    District.all.each do |d|
      CreateInterventionPdfs.generate(d)  rescue Errno::EACCES
    end
  end

  def self.run_weekly
    Notifications.setup_ending_reminders() #run for all districts
  end

end
