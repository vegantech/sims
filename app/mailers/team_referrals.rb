class TeamReferrals < MailerWithSubdomains
  layout 'email'
  default :from => DEFAULT_EMAIL

  def concern_note_created(note, sent_at = Time.now)
    subject =    'Team Consultation Form Created'
    recipients= note.recipients.collect(&:email).join(",")
    @district = note.student.district
    @recipient_name= note.recipients.join(", ")
    @student_name = note.student.fullname
    @requestor_name = note.requestor.fullname
    @note =note
    mail(:subject => subject, :to => recipients, :subject => subject)
  end

  def gather_information_request(users, student, requestor,sent_at = Time.now)
    subject=    'Consultation Form Request'
    recipients= users.collect(&:email).uniq.compact.join(",")
    @district = student.district
    @users = users
    @student = student
    @requestor = requestor
    mail(:subject => subject, :to => recipients, :subject => subject)
  end


  def concern_note_withdrawn(note, sent_at = Time.now)
    subject=    'Team Consultation Form Withdrawn'
    recipients= note.recipients.collect(&:email).join(",")
    @district = note.student.district
    @recipient_name= note.recipients.join(", ")
    @student_name = note.student.fullname
    @requestor_name = note.requestor.fullname,
    @note = note

    mail(:subject => subject, :to => recipients, :subject => subject)
  end

end
