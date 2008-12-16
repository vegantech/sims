require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TeamNotesReport do
  describe 'render_html' do
    # TODO: Figure out why this passes when run by itself, but fails with duplicated report body when run as part of the default rake task!
     it 'should generate correct text output' do
       student = Student.create!
     
       user = Factory(:user, :username => 'some_user', :first_name => 'Some', :last_name => 'User')
     
       start_date = Date.new(2008, 12, 11)
       end_date = Date.new(2008, 12, 13)
       sc1 = StudentComment.create!(:student => student, :user => user, :body => 'First Comment', :created_at => start_date.to_time)
       sc2 = StudentComment.create!(:student => student, :user => user, :body => 'Second Comment', :created_at => end_date.to_time)
       StudentComment.should_receive(:find).and_return([sc1, sc2])
       Time.should_receive(:now).twice.and_return(Date.new(2008, 12, 12).to_time)
     
       report_body = TeamNotesReport.render_text(:user => user, :start_date => start_date, :end_date => end_date)
       
       report_body.should == "Report Generated at December 12, 2008 00:00\n\n :\n\n+---------------------------------------+\n|   Date   | User Name |   Team Note    |\n+---------------------------------------+\n| 12/11/08 | some_user | First Comment  |\n| 12/13/08 | some_user | Second Comment |\n+---------------------------------------+\n\n"
     end
  end
end
