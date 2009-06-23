# == Schema Information
# Schema version: 20090623023153
#
# Table name: user_school_assignments
#
#  id         :integer(4)      not null, primary key
#  school_id  :integer(4)
#  user_id    :integer(4)
#  admin      :boolean(1)
#  created_at :datetime
#  updated_at :datetime
#

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
