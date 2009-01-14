class DailyJobs
  def self.run
    self.regenerate_intervention_reports
  end

  def self.regenerate_intervention_reports
    District.all.each do |d|
      CreateInterventionPdfs.generate(d)
    end
  end

end
