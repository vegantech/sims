require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CicoStudentDay do
  before(:each) do
    @valid_attributes = {
      :cico_school_day => CicoSchoolDay.new,
      :intervention_probe_assignment => InterventionProbeAssignment.new,
      :score => 1,
      :status => 1
    }
  end

  it "should create a new instance given valid attributes" do
    CicoStudentDay.create!(@valid_attributes)
  end
end
