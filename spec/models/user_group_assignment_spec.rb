# == Schema Information
# Schema version: 20081223233819
#
# Table name: user_group_assignments
#
#  id           :integer         not null, primary key
#  user_id      :integer
#  group_id     :integer
#  is_principal :boolean
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
