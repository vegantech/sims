# == Schema Information
# Schema version: 20101027022939
#
# Table name: school_team_memberships
#
#  id             :integer(4)      not null, primary key
#  school_team_id :integer(4)
#  user_id        :integer(4)
#  contact        :boolean(1)
#  created_at     :datetime
#  updated_at     :datetime
#

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
