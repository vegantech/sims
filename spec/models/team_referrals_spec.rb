require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe TeamReferrals do
  describe "concern_note_created" do
   it 'should send the email' do
     
      user=Factory(:user, :email => 'bob@e.fg')
      student = Factory(:student, :district => user.district)
      team = SchoolTeam.create!(:name => 'Testing', :contact => user.id)

      note = TeamConsultation.new(:student=>student,:requestor => user, :school_team => team )


      proc{@mail=TeamReferrals.deliver_concern_note_created(note)}.should change(ActionMailer::Base.deliveries,:size).by(1)
      @mail.subject.should ==  'Team Consultation Form Created'
      @mail.header["to"].to_s.should ==  user.email
      @mail.body.should == "A team consultation form has been generated for (First Last) on #{Time.now.to_date} by (#{user.first_name} Last_Name). Please schedule an initial discussion at an upcoming team meeting.\n\n\n\n"


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
      @mail.body.should == "First Last has been discussed at our team meeting.  \nPlease share information based on your perspective by going to <a href=\"http://www.#{student.district.abbrev}.sims_test_host/students/#{student.id}\">First Last</a>, then click on Respond to Request for Information under the Team Notes heading.\n\n\nRequested by: #{requestor.first_name} Last_Name\n"
    end
  end

end
