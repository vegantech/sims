# == Schema Information
# Schema version: 20090325221606
#
# Table name: user_school_assignments
#
#  id         :integer         not null, primary key
#  school_id  :integer
#  user_id    :integer
#  admin      :boolean
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
