class Notifications < MailerWithSubdomains
  layout 'email'
  default :from => DEFAULT_EMAIL
  #  alias_method_chain @url_for, @subdomain
#  def url_for_with_subdomain(opts ={})
#    raise 'missing district' if @district.blank?
#  end


  def change_password(user)
    @district = user.district
    subject  =  '[SIMS] Email Registration/ Change Password'
    recipients = user.email

    @user=user

    mail(:subject => subject, :to => recipients, :subject => subject)
  end


  def principal_override_request(override)
    subject =   '[SIMS] Principal Override Request'
    recipients = override.student.principals.collect(&:email).join(',')
    @district = override.student.district

    @override =override
    mail(:subject => subject, :to => recipients, :subject => subject)
  end

  def principal_override_response(override)
    subject =   "[SIMS] Principal Override #{override.action.capitalize}ed"
    recipients = override.teacher.email
    @district = override.student.district

    @override = override
    mail(:subject => subject, :to => recipients, :subject => subject)
  end

  def intervention_starting(interventions)
    interventions= Array(interventions)
    participants= interventions.first.participants_with_author
    watcher = interventions.first.try(:intervention_definition).try(:notify_email)
    watcher = nil unless watcher.to_s.include?("@")

    recipients =  participants.collect(&:email).uniq.join(',')
    subject  =  '[SIMS]  Student Intervention Starting'
    @district = interventions.first.try(:student).try(:district)

    @participants = participants
    @interventions = interventions
    mail(:subject => subject, :to => recipients, :subject => subject, :cc => watcher)
  end

  def intervention_ending_reminder(user,interventions, sent_at = Time.now)
    subject =   '[SIMS] Student Intervention(s) Ending This Week'
    recipients = user.email
    @district = user.district

    @user = user
    @interventions = interventions
    mail(:subject => subject, :to => recipients, :subject => subject)
  end

  def intervention_reminder(sent_at = Time.now)
    subject  =  'Notifications#intervention_reminder'
    recipients =  ''
    mail(:subject => subject, :to => recipients, :subject => subject)

  end

  def intervention_participant_added(intervention_person,intervention=nil)
    subject =    '[SIMS]  Student Intervention New Participant'
    intervention_person = Array(intervention_person)
    @intervention_person = intervention_person.first
    @intervention = Array(intervention || @intervention_person.intervention).first
    recipients =@intervention_person.email
    @district = @intervention_person.user.district
    @participants = @intervention.participants_with_author
    @interventions = Array(intervention)
   # intervention_person.collect(&:intervention)
    @participant = @intervention_person
    mail(:subject => subject, :to => recipients, :subject => subject)
  end


  def special_ed_referral rec, user_name, user_email, student
    @subject = 'SIMS- Checklist Completed'
    @recommendation = rec  unless rec.blank?
    @student=student
    @headers = {}

    @user_name= user_name
    @recipients = user_email
    @district = student.district

    mail(:subject => subject, :to => recipients, :subject => subject)
  end

  def district_upload_results msg, admin_email
    subject = 'SIMS Upload Results'
    recipients = admin_email
    @msg = msg
    mail(:subject => subject, :to => recipients)
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
        self.intervention_ending_reminder(user,interventions).deliver
        rescue Exception => e
          errors << "#{e.message} for #{user} #{interventions.collect(&:id)}"
        end
      end
      puts errors.inspect unless errors.blank?
  end

  def self.interventions_ending_this_week
    interventions = Intervention.active.find(:all, :conditions=>{"end_date" =>(Date.today..7.day.from_now.to_date)})
    interventions.reject{|i| i.student.blank?}
  end

end
