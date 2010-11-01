# == Schema Information
# Schema version: 20101101011500
#
# Table name: school_teams
#
#  id         :integer(4)      not null, primary key
#  school_id  :integer(4)
#  name       :string(255)
#  anonymous  :boolean(1)
#  created_at :datetime
#  updated_at :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SchoolTeam do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :anonymous => true,
#      :contact_ids => [2]

    }
  end

  it "should create a new instance given valid attributes" do
    SchoolTeam.create!(@valid_attributes)
  end
end
