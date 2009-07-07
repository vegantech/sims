require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SchoolTeamMembership do
  before(:each) do
    @valid_attributes = {
      :contact => false
    }
  end

  it "should create a new instance given valid attributes" do
    SchoolTeamMembership.create!(@valid_attributes)
  end
end
