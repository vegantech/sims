# == Schema Information
# Schema version: 20090524185436
#
# Table name: school_teams
#
#  id         :integer         not null, primary key
#  school_id  :integer
#  name       :string(255)
#  anonymous  :boolean
#  created_at :datetime
#  updated_at :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SchoolTeam do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :anonymous => false
    }
  end

  it "should create a new instance given valid attributes" do
    SchoolTeam.create!(@valid_attributes)
  end
end
