class TeamReferrals < ActionMailer::Base

  def concern_note_created(note, sent_at = Time.now)
    subject    'Team Consultation Form Created'
    recipients note.recipient.email
    from       'SIMS <b723176@madison.k12.wi.us>'
    sent_on    sent_at
    
    body       :greeting => 'Hi,', :recipient_name=>note.recipient.fullname, :student_name => note.student.fullname, :requestor_name => note.requestor.fullname, :note=>note
  end

  def gather_information_request(sent_at = Time.now)
    subject    'TeamReferrals#gather_information_request'
    recipients ''
    from       ''
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

end
