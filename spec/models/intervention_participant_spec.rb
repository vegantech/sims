# == Schema Information
# Schema version: 20090325221606
#
# Table name: intervention_participants
#
#  id              :integer         not null, primary key
#  intervention_id :integer
#  user_id         :integer
#  role            :integer         default(1)
#  created_at      :datetime
#  updated_at      :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InterventionParticipant do

  it "should create a new instance given valid attributes" do
    Factory(:intervention_participant)
  end
end
