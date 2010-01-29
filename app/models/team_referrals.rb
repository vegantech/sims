class TeamReferrals < MailerWithSubdomains
  helper :application

  def concern_note_created(note, sent_at = Time.now)
    subject    'Team Consultation Form Created'
    recipients note.recipient.email
    from       'SIMS <shawn@simspilot.org>'
    sent_on    sent_at

    @district = note.student.district

    
    body       :greeting => 'Hi,', :recipient_name=>note.recipient.fullname, :student_name => note.student.fullname, :requestor_name => note.requestor.fullname, :note=>note
  end

  def gather_information_request(users, student, requestor,sent_at = Time.now)
    subject    'Consultation Form Request'
    recipients users.collect(&:email).uniq.compact.join(",")
    from       'SIMS <shawn@simspilot.org>'
    sent_on    sent_at
    @district = student.district
    body       :greeting => 'Hi,', :users => users, :student => student , :requestor => requestor
  end

end
