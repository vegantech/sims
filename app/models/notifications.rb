class Notifications < ActionMailer::Base
  if RAILS_ENV == 'production'

   if defined?DEFAULT_URL
     default_url_options[:host] = 'www.simspilot.org'
     default_url_options[:protocol]='https'
   else
     default_url_options[:host] = 'sims-open.vegantech.com'
     default_url_options[:port] = 80
   end
  else

    default_url_options[:host] = 'localhost'
    default_url_options[:port] = 3000
  end

  def setup_url(district)
    if defined?DEFAULT_URL &&  RAILS_ENV == 'production'
      default_url_options[:protocol]='https'
      default_url_options[:host]="#{district.abbrev}.simspilot.org"
    end
  end


  def principal_override_request(override)
    subject    '[SIMS] Principal Override Request'
    recipients override.student.principals.collect(&:email).join(',')
    from       'SIMS <sims@simspilot.org>'
    sent_on    Time.now
    
    body       :override=>override
  end

  def principal_override_response(override)
    subject    "[SIMS] Principal Override #{override.action.capitalize}ed"
    recipients override.teacher.email
    from       'SIMS <sims@simspilot.org>'
    sent_on    Time.now
    
    body       :override => override
  end

  def intervention_starting(interventions)
    interventions=Array(interventions)
    participants=interventions.first.participants_with_author

    setup_url(interventions.first.user.district)
    recipients  participants.collect(&:email).uniq.join(',')
    subject    '[SIMS]  Student Intervention Starting'
    from       'SIMS <sims@simspilot.org>'
    sent_on    Time.now
    
    body       :greeting => 'Hi,', :participants=> participants, :interventions=> interventions
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

  def intervention_participant_added(intervention_person)
    subject    '[SIMS]  Student Intervention New Participant'
    from       'SIMS <sims@simspilot.org>'
    recipients intervention_person.user.email
    setup_url(intervention_person.user.district)
    sent_on    Time.now
    body       :greeting => 'Hi,', :participants => intervention_person.intervention.participants_with_author,
                :interventions=> [intervention_person.intervention],:participant => intervention_person
  end

end
