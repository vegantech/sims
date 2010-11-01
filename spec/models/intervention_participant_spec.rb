# == Schema Information
# Schema version: 20101101011500
#
# Table name: intervention_participants
#
#  id              :integer(4)      not null, primary key
#  intervention_id :integer(4)
#  user_id         :integer(4)
#  role            :integer(4)      default(1)
#  created_at      :datetime
#  updated_at      :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InterventionParticipant do

  it "should create a new instance given valid attributes" do
    Factory(:intervention_participant)
  end
end
