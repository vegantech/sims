# == Schema Information
# Schema version: 20090623023153
#
# Table name: team_schedulers
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  school_id  :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TeamScheduler do
  before(:each) do
    @valid_attributes = {
    }
  end

  it "should create a new instance given valid attributes" do
    TeamScheduler.create!(@valid_attributes)
  end
end
