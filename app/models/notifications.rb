class Notifications < MailerWithSubdomains

#  alias_method_chain :url_for, :subdomain
#  def url_for_with_subdomain(opts ={})
#    raise 'missing district' if @district.blank?
#  end


  def change_password(user)
    @district=user.district
    subject    '[SIMS] Email Registration'
    recipients user.email
    from       'SIMS <sims@simspilot.org>'
    sent_on    Time.now
    
    body       :user=>user
 
  end


  def principal_override_request(override)
    subject    '[SIMS] Principal Override Request'
    recipients override.student.principals.collect(&:email).join(',')
    from       'SIMS <sims@simspilot.org>'
    sent_on    Time.now
    @district = override.student.district
    
    body       :override=>override
  end

  def principal_override_response(override)
    subject    "[SIMS] Principal Override #{override.action.capitalize}ed"
    recipients override.teacher.email
    from       'SIMS <sims@simspilot.org>'
    sent_on    Time.now
    @district = override.student.district
    
    body       :override => override
  end

  def intervention_starting(interventions)
    interventions=Array(interventions)
    participants=interventions.first.participants_with_author

    recipients  participants.collect(&:email).uniq.join(',')
    subject    '[SIMS]  Student Intervention Starting'
    from       'SIMS <sims@simspilot.org>'
    sent_on    Time.now
    @district = interventions.first.student.district
    
    body       :greeting => 'Hi,', :participants=> participants, :interventions=> interventions
  end

  def intervention_ending_reminder(user,interventions, sent_at = Time.now)
    subject    '[SIMS] Student Intervention(s) Ending This Week'
    recipients user.email
    from       'SIMS <sims@simspilot.org>'
    sent_on    sent_at
    @district = user.district
   
    body       :greeting => 'Hi,', :user => user, :interventions => interventions
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
    sent_on    Time.now
    @district = intervention_person.user.district
    body       :greeting => 'Hi,', :participants => intervention_person.intervention.participants_with_author,
                :interventions=> [intervention_person.intervention],:participant => intervention_person
  end

  def special_ed_referral rec, user_name, user_email, student
    @subject = 'SIMS- Checklist Completed'
    @body['recommendation'] = rec  unless rec.blank?
    @body['student']=student
    @from                     = 'SIMS <shawn@simspilot.org>'
    @headers = {}

    @body['user_name']= user_name
    @recipients = user_email
    @district = student.district
    
  end

  def district_upload_results msg, admin_email
    @subject = 'SIMS Upload Results'
    @from                     = 'SIMS <shawn@simspilot.org>'
    @recipients = admin_email
    @body['msg'] = msg
    
    
  end

  def self.setup_ending_reminders(district = nil)
    errors = []
    users_with_interventions = Hash.new([])
    interventions_ending_this_week.each do |intervention| 
      if district.blank? || intervention.participants_with_author.collect(&:user).compact.collect(&:district_id).include?(district.id)
        intervention.participants_with_author.each{|p| users_with_interventions[p.user] |= [intervention] if p.user && intervention.student.belongs_to_user?(p.user)}
      end
    end
      users_with_interventions.each do |user,interventions|
        begin
        self.deliver_intervention_ending_reminder(user,interventions)
        rescue Exception => e
          errors << "#{e.message} for #{user} #{interventions.collect(&:id)}"
        end
      end
    puts errors.inspect
  end

  def self.interventions_ending_this_week
    interventions = Intervention.active.find(:all, :conditions=>{"end_date" =>(Date.today..7.day.from_now.to_date)})
    interventions.reject{|i| i.student.blank?}
  end

end
