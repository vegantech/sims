require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UserSchoolAssignment do
  before(:each) do
    @valid_attributes = {
      :school => nil,
      :user => nil,
      :admin => false
    }
  end

  it "should create a new instance given valid attributes" do
    pending
    UserSchoolAssignment.create!(@valid_attributes)
  end
end
