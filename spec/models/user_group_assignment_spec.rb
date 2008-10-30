require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UserGroupAssignment do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :group_id => 1,
      :is_principal => false
    }
  end

  it "should create a new instance given valid attributes" do
    UserGroupAssignment.create!(@valid_attributes)
  end
end
