# == Schema Information
# Schema version: 20090524185436
#
# Table name: team_schedulers
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  school_id  :integer
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
