require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StudentObserver do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :days => "1"
    }
  end

  describe 'historical enrollments' do
    it 'should create a district historical enrollment when the student is created' do
      HistoricalEnrollment.delete_all
      student=Factory(:student)
      student.should have(1).historical_enrollments
      his_enroll= student.district.historical_enrollments.first

      his_enroll.district.should == student.district
      his_enroll.student.should == student
      his_enroll.school.should be_blank
      his_enroll.end_date.should be_blank
      his_enroll.start_date.should_not be_blank


    end

    it 'should create a district historical enrollment when the student is assigned to a district' do
    end

    it 'should end a district historical enrollment when the student is removed from a district' do
    end

    it 'should end a district historical enrollment and create a new one when the student is claimed by another district (and yanked)' do
    end

    it 'should not do anything if the district is unchanged' do
      HistoricalEnrollment.delete_all
      student=Factory(:student)
      student.should have(1).historical_enrollments
      he = student.historical_enrollments.first
      old_attribs = he.attributes
      student.first_name = 'new'
      student.save
      he.reload.attributes.should ==(old_attribs)

    end



  end

  it "should create a new instance given valid attributes" do
    #TimeLength.create!(@valid_attributes)
  end
end


