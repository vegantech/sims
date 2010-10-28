# == Schema Information
# Schema version: 20101027022939
#
# Table name: staff_assignments
#
#  id        :integer(4)      not null, primary key
#  school_id :integer(4)
#  user_id   :integer(4)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StaffAssignment do
  before(:each) do
    @valid_attributes = {
    }
  end

  it "should create a new instance given valid attributes" do
    StaffAssignment.create!(@valid_attributes)
  end
end
