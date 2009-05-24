class TeamReferrals < ActionMailer::Base

  def url_opts
    h={}
    if defined?SIMS_DOMAIN
      h[:host]=SIMS_DOMAIN
      h[:protocol]=SIMS_PROTO
      h[:only_path] = false
    else
      h[:only_path] = true
    end
    h
  end
  def concern_note_created(note, sent_at = Time.now)
    subject    'Team Consultation Form Created'
    recipients note.recipient.email
    from       'SIMS <b723176@madison.k12.wi.us>'
    sent_on    sent_at
    
    body       :greeting => 'Hi,', :recipient_name=>note.recipient.fullname, :student_name => note.student.fullname, :requestor_name => note.requestor.fullname, :note=>note
  end

  def gather_information_request(users, student, requestor,sent_at = Time.now)
    subject    'Consultation Form Request'
    recipients users.collect(&:email).uniq.compact.join(",")
    from       'SIMS <b723176@madison.k12.wi.us>'
    sent_on    sent_at
    body       :greeting => 'Hi,', :users => users, :student => student , :requestor => requestor, :url_opts => url_opts
  end

end
