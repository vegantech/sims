require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FlagsForStudentReport do
  describe 'render_text' do
    it 'should generate correct text output' do
      now = Date.new(2008, 12, 12).to_time
      Time.stub!(:now => now)

      d = mock_district
      user = User.create!(:district => d, :username => 'username', :first_name => 'First', :last_name => 'Last', :password => 'pword')
      flag1 = CustomFlag.create!(:category => 'math', :reason => 'Does not know addition tables.', :updated_at => now, :user => user)
      flag2 = SystemFlag.create!(:category => 'languagearts', :reason => 'Reading below grade level', :updated_at => now, :user => user)
      student = Factory(:student, :flags => [flag1, flag2])

      report_body = FlagsForStudentReport.render_text(:student => student)

      report_body.should == <<EOS
SystemFlag:

+---------------------------------------------------------------------------------+
|   category   |          reason           |  user_id   |       updated_at        |
+---------------------------------------------------------------------------------+
| languagearts | Reading below grade level | First Last | December 12, 2008 00:00 |
+---------------------------------------------------------------------------------+

CustomFlag:

+----------------------------------------------------------------------------------+
| category |             reason             |  user_id   |       updated_at        |
+----------------------------------------------------------------------------------+
| math     | Does not know addition tables. | First Last | December 12, 2008 00:00 |
+----------------------------------------------------------------------------------+

EOS
    end
  end
end