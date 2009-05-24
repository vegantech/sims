require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SchoolTeam do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :anonymous => false
    }
  end

  it "should create a new instance given valid attributes" do
    SchoolTeam.create!(@valid_attributes)
  end
end
