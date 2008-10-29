require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InterventionProbeAssignment do
  before(:each) do
    @valid_attributes = {
      :frequency_multiplier => "1",
      :first_date => Time.now,
      :end_date => Time.now,
      :enabled => false
    }
  end

  it "should create a new instance given valid attributes" do
    InterventionProbeAssignment.create!(@valid_attributes)
  end
end
