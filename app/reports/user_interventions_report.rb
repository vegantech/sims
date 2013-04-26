class UserInterventionsReport
  def self.author_or_participant(user_id)
    Intervention.includes([:intervention_participants, :user,:frequency, :time_length, :intervention_definition]).where(
      ["interventions.user_id = :user_id or intervention_participants.user_id = :user_id", {:user_id => user_id}])
  end

  def self.for_user_interventions_report(user_id, filter,start_date = 5.years.ago,end_date = Date.today)
    ints = author_or_participant(user_id).where(:updated_at => start_date..(end_date+2))
    if filter == "Current"
      ints = ints.where(["active = ?",true])
    elsif filter == "Ended"
      ints = ints.where(["active = ?",false])
    end
    ints
  end
end

