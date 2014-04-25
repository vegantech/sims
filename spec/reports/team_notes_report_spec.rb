require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TeamNotesReport do
  describe 'render_text' do
    it 'should generate correct text output' do
      pending 'this needs different tests and cucumber features for the results'
      student = Factory(:student, first_name: 'This', last_name: 'Student')
      school = Factory(:school, district_id: student.district_id)
      student.enrollments.create!(school: school, grade: "05")

      user = Factory(:user, username: 'some_user', first_name: 'Some', last_name: 'User')
      user.special_user_groups.create!(grouptype: SpecialUserGroup::ALL_STUDENTS_IN_DISTRICT, district_id: school.district_id)

      start_date = Date.new(2008, 12, 11)
      end_date = Date.new(2008, 12, 13)
      sc1 = Factory(:student_comment, student: student, user: user, body: 'First Comment', created_at: Time.zone.parse(start_date.to_s))
      sc2 = Factory(:student_comment, student: student, user: user, body: 'Second Comment', created_at: Time.zone.parse(end_date.to_s))
      StudentComment.should_receive(:find).and_return([sc1, sc2])
      Time.stub!(now: Date.new(2008, 12, 12).to_time)

      report_body = TeamNotesReport.render_text(user: user, start_date: start_date, end_date: end_date, school: school)

      report_body.should == <<EOS
Report Generated at December 12, 2008 00:00

This Student:

+-----------------------------------------+
|    Date    | User Name |   Team Note    |
+-----------------------------------------+
| 12/11/2008 | Some User | First Comment  |
| 12/13/2008 | Some User | Second Comment |
+-----------------------------------------+

EOS
    end
  end
end
