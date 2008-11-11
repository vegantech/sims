require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PrincipalOverride do
  before(:each) do
    @valid_attributes = {
      :status => "1",
      :teacher_request => "value for fufillment_reason",
      :student=>mock_student(:max_tier=>Tier.new(:title=>"TIER 1"))
    }
  end

  it "should create a new instance given valid attributes" do
    PrincipalOverride.create!(@valid_attributes)
  end
end
