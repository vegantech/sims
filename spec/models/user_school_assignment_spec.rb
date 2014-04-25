# == Schema Information
# Schema version: 20101101011500
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
      school: nil,
      user: nil,
      admin: false
    }
  end

  it "should create a new instance given valid attributes" do
    pending
    UserSchoolAssignment.create!(@valid_attributes)
  end

  it "should remove special user groups when it is removed" do
    UserSchoolAssignment.delete_all
    SpecialUserGroup.delete_all
    usa = UserSchoolAssignment.create!(user_id: 1, school_id: 1)
    sug = SpecialUserGroup.new(school_id: 1, user_id: 1)
    sug.save!
    SpecialUserGroup.count.should == 1
    usa.destroy
    SpecialUserGroup.count.should == 0
  end
end
