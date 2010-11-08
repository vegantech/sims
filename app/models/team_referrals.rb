class TeamReferrals < MailerWithSubdomains
  layout 'email'

  def concern_note_created(note, sent_at = Time.now)
    subject    'Team Consultation Form Created'
    recipients note.recipients.collect(&:email).join(",")
    sent_on    sent_at

    @district = note.student.district

    
    body       :greeting => 'Hi,', :recipient_name=>note.recipients.join(", "), :student_name => note.student.fullname, :requestor_name => note.requestor.fullname, :note=>note
  end

  def gather_information_request(users, student, requestor,sent_at = Time.now)
    subject    'Consultation Form Request'
    recipients users.collect(&:email).uniq.compact.join(",")
    sent_on    sent_at
    @district = student.district
    body       :greeting => 'Hi,', :users => users, :student => student , :requestor => requestor
  end


  def concern_note_withdrawn(note, sent_at = Time.now)
    subject    'Team Consultation Form Withdrawn'
    recipients note.recipients.collect(&:email).join(",")
    sent_on    sent_at

    @district = note.student.district

    
    body       :greeting => 'Hi,', :recipient_name=>note.recipients.join(", "), :student_name => note.student.fullname, :requestor_name => note.requestor.fullname, :note=>note
  end



end
