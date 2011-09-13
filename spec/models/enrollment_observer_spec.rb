require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EnrollmentObserver do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :days => "1"
    }
  end

  describe 'historical enrollments' do
    it 'should create a district historical enrollment when the student is created' do

    end

    it 'should create a district historical enrollment when the student is assigned to a district' do
    end

    it 'should end a district historical enrollment when the student is removed from a district' do
    end

    it 'should end a district historical enrollment and create a new one when the student is claimed by another district (and yanked)' do
    end

    it 'should not do anything if the district is unchanged' do
    end



  end

  it "should create a new instance given valid attributes" do
    #TimeLength.create!(@valid_attributes)
  end
end
