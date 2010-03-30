class DailyJobs
  def self.run
    CreateTrainingDistrict.generate  if  defined?(SIMS_DOMAIN) && SIMS_DOMAIN == "sims-open.vegantech.com"
    self.regenerate_intervention_reports

  end

  def self.regenerate_intervention_reports
    District.all.each do |d|
      CreateInterventionPdfs.generate(d)
    end
  end

  def self.run_weekly
    self.reset_demo if ENV['RESET_DEMO'] && defined?(SIMS_DOMAIN) && SIMS_DOMAIN == "sims-open.vegantech.com"
    Notifications.setup_ending_reminders() #run for all districts
  end

  def self.reset_demo
    if ENV['RESET_DEMO'] #being paranoid here
      Intervention.destroy_all
      CustomFlag.destroy_all
      Checklist.destroy_all
      Recommendation.destroy_all
      PrincipalOverride.destroy_all
      StudentComment.destroy_all
      RailmailDelivery.destroy_all if defined?RailmailDelivery
      ConsultationForm.destroy_all
      ConsultationFormRequest.destroy_all
      TeamConsultation.destroy_all
      puts "Reset Demo"
    else
      puts 'ENV RESET_DEMO not set,  requiring this just to be safe'
    end
  end

end
