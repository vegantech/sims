require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/import_base.rb')

describe CSVImporter::Enrollments do
  it_should_behave_like "csv importer"
  describe "importer"  do
    it 'should work properly' do
      #be sure to test with existing admin
      School.delete_all
      Enrollment.delete_all
      District.delete_all
      Student.delete_all

      @district=Factory(:district)
      @school_no_link = Factory(:school, :district_id => @district.id)
      @school_with_link = Factory(:school, :district_id => @district.id, :district_school_id => 1)
      @student_without_link = Factory(:student, :district_id => @district.id)
      @student_with_link = Factory(:student, :district_id => @district.id, :district_student_id => 'student_with_link')

      @student_with_link.enrollments.create!(:grade=>'01', :school_id => @school_no_link.id)
      @student_without_link.enrollments.create!(:grade=>'01', :school_id => @school_no_link.id)
      @student_without_link.enrollments.create!(:grade=>'01', :school_id => @school_with_link.id)

      @should_lose_enrollment = Factory(:student,:district_id => @district.id,  :district_student_id => 'lose_enrollment')
      @should_lose_enrollment.enrollments.create!(:grade => 'gone', :school_id => @school_with_link.id)


      @should_keep_enrollment = Factory(:student,:district_id => @district.id,  :district_student_id => 'keep_enrollment')
      @should_keep_enrollment.enrollments.create!(:grade => '01', :school_id => @school_with_link.id)
      @should_keep_enrollment.enrollments.create!(:grade => 'grade_should_go', :school_id => @school_with_link.id)

      @should_gain_enrollment = Factory(:student,:district_id => @district.id,  :district_student_id => 'gain_enrollment')
      @i=CSVImporter::Enrollments.new "#{Rails.root}/spec/csv/enrollments.csv",@district
      @i.import

      @student_with_link.enrollments.size.should == 1
      @student_without_link.enrollments.size.should == 2

      @should_lose_enrollment.enrollments.count.should == 0
      
      @should_gain_enrollment.enrollments.count.should == 2 #2 grades and years in csv

      @should_keep_enrollment.enrollments.count.should == 1
    end

  end
end




