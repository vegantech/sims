class Notifications < ActionMailer::Base
  

  def principal_override_request(sent_at = Time.now)
    subject    'Notifications#principal_override_request'
    @recipients ''
    from       ''
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

  def principal_override_response(sent_at = Time.now)
    subject    'Notifications#principal_override_response'
    @recipients ''
    from       ''
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

  def intervention_starting(interventions)
    interventions=Array(interventions)
    participants=interventions.first.participants_with_author
    @recipients = participants.collect(&:email).uniq.join(',')
    subject    'Student Intervention Starting'
    from       'SIMS <b723176@madison.k12.wi.us>'
    sent_on    Time.now
    
    body       :greeting => 'Hi,', :participants=> participants, :interventions=> interventions
  end

  def intervention_ending_reminder(sent_at = Time.now)
    subject    'Notifications#intervention_ending_reminder'
    @recipients ''
    from       ''
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

  def intervention_reminder(sent_at = Time.now)
    subject    'Notifications#intervention_reminder'
    @recipients ''
    from       ''
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

  def intervention_participant_added(sent_at = Time.now)
    subject    'Notifications#intervention_participant_added'
    @recipients ''
    from       ''
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

end
