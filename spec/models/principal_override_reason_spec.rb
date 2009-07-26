require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PrincipalOverrideReason do
  before(:each) do
    @valid_attributes = {
      :reason => "value for reason",
      :autopromote => false
    }
  end


  it "needs tests"
  it "should create a new instance given valid attributes" do
    PrincipalOverrideReason.create!(@valid_attributes)
  end
end
