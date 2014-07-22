class TeamReferrals < MailerWithSubdomains
  layout 'email'
  default :from => DEFAULT_EMAIL

  def concern_note_created(note, _sent_at = Time.now)
    subject =    "Team Consultation Form Created -- #{note.school_team_name}"
    recipients= note.recipients.collect(&:email).join(",")
    @district = note.student.district
    @recipient_name= note.recipients.join(", ")
    @student_name = note.student.fullname
    @requestor_name = note.requestor.fullname
    @note =note
    mail(:subject => subject, :to => recipients)
  end

  def concern_note_response(response, _sent_at = Time.now)
    note = response.team_consultation
    subject =    "Team Consultation Form Response -- #{note.school_team_name}"
    recipients= note.recipients.collect(&:email).join(",")
    @district = note.student.district
    @recipient_name= note.recipients.join(", ")
    @student_name = note.student.fullname
    @requestor_name = response.user.fullname
    @note =note
    mail(:subject => subject, :to => recipients)
  end

  def gather_information_request(users, student, requestor,_sent_at = Time.now)
    subject=    'Consultation Form Request'
    recipients= users.collect(&:email).uniq.compact.join(",")
    @district = student.district
    @users = users
    @student = student
    @requestor = requestor
    mail(:subject => subject, :to => recipients)
  end

  def concern_note_withdrawn(note, _sent_at = Time.now)
    subject=    "Team Consultation Form Withdrawn -- #{note.school_team_name}"
    recipients= note.recipients.collect(&:email).join(",")
    @district = note.student.district
    @recipient_name= note.recipients.join(", ")
    @student_name = note.student.fullname
    @requestor_name = note.requestor.fullname
    @note = note

    mail(:subject => subject, :to => recipients)
  end

end
