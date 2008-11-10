class Notifications < ActionMailer::Base
  

  def principal_override_request(sent_at = Time.now)
    subject    'Notifications#principal_override_request'
    recipients ''
    from       ''
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

  def principal_override_response(sent_at = Time.now)
    subject    'Notifications#principal_override_response'
    recipients ''
    from       ''
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

  def intervention_starting(sent_at = Time.now)
    subject    'Notifications#intervention_starting'
    recipients ''
    from       ''
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

  def intervention_ending_reminder(sent_at = Time.now)
    subject    'Notifications#intervention_ending_reminder'
    recipients ''
    from       ''
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

  def intervention_reminder(sent_at = Time.now)
    subject    'Notifications#intervention_reminder'
    recipients ''
    from       ''
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

  def intervention_participant_added(sent_at = Time.now)
    subject    'Notifications#intervention_participant_added'
    recipients ''
    from       ''
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

end
