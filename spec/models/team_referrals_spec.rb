require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe TeamReferrals do
  describe "concern_note_created" do
   it 'should send the email' do
      user=Factory(:user, :email => 'bob@e.fg')
      student = Factory(:student, :district => user.district)
      team = SchoolTeam.create!(:name => 'Testing', :contact_ids => [user.id])

      note = TeamConsultation.new(:student=>student,:requestor => user, :school_team => team )


      proc{@mail=TeamReferrals.deliver_concern_note_created(note)}.should change(ActionMailer::Base.deliveries,:size).by(1)
      @mail.subject.should ==  'Team Consultation Form Created'
      @mail.header["to"].to_s.should ==  user.email
      expected_body =  "A team consultation form has been generated for (First Last) on #{Time.now.to_date} by (#{user.first_name} Last_Name). Please schedule an initial discussion at an upcoming team meeting.\r\n\r\n\r\n\r\n\r\nThis is an automated message sent by SIMS.  If you have questions about the content of this message, \r\n     please contact the participants directly.  Replies to this message are not regularly reviewed.\r\n"
      puts expected_body
      @mail.body.raw_source.should == expected_body

    end
  end

  describe "gather_information_request" do
    it 'should send the email' do

      oldurl_opts = TeamReferrals.default_url_options
      user=Factory(:user, :email => 'one@bob.com')
      user2=Factory(:user, :district => user.district, :email => 'two@bob.com')
      student = Factory(:student, :district => user.district)
      users=[user,user2]
      requestor = user
      sims_domain = "sims_test_host"

      student.district.should == user.district



      proc{@mail=TeamReferrals.deliver_gather_information_request(users,student,requestor)}.should change(ActionMailer::Base.deliveries,:size).by(1)
      @mail.subject.should ==  'Consultation Form Request'
      @mail.header["to"].to_s.should ==  "#{user.email}, #{user2.email}"
      @mail.body.raw_source.should == "A TEAM MEMBER HAS GENERATED A TEAM CONSULTATION FORM FOR First Last.\r\n\r\nPlease share information based on your perspective by going to http://#{student.district.abbrev}.sims_test_host/students/#{student.id} (First Last), \r\nthen click on Respond to Request for Information under the Team Consultations section of SIMS.\r\n\r\n\r\nRequested by: #{requestor.first_name} Last_Name\r\n\r\n\r\nThis is an automated message sent by SIMS.  If you have questions about the content of this message, \r\n     please contact the participants directly.  Replies to this message are not regularly reviewed.\r\n"
    end
  end

end
