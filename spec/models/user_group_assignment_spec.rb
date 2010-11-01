# == Schema Information
# Schema version: 20101101011500
#
# Table name: user_group_assignments
#
#  id           :integer(4)      not null, primary key
#  user_id      :integer(4)
#  group_id     :integer(4)
#  is_principal :boolean(1)
#  created_at   :datetime
#  updated_at   :datetime
#

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
