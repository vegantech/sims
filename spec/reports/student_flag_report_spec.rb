require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StudentFlagReport do
  describe 'render_text' do
    it 'should generate correct text output' do
      @school=Factory(:school)
      @student=Factory(:student, :first_name=>"Student1")
      @student.enrollments.create!(:school=>@school, :grade=>"3")
      @student2=Factory(:student, :first_name=>"Student2")
      @student2.enrollments.create!(:school=>@school, :grade=>"3")
     
      @student.custom_flags.create!(:category=>"suspension", :reason=>"Custom Behavior")
      @student.ignore_flags.create!(:category=>"math", :reason=>"Ignored Math")
      @student.system_flags.create!(:category=>"attendance", :reason=>"Attendance rate of 25%")

     
      report_body = StudentFlagReport.render_text(:school => @school, :grade=>"3")


      pending 'This really is not implemented properly yet'
      report_body = StudentFlagReport.render_text(:school => @school, :grade=>"3")

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
