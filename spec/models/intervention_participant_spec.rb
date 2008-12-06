# == Schema Information
# Schema version: 20081205205925
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
  before(:each) do
    @valid_attributes = {
      :role => "1"
    }
  end

  it "should create a new instance given valid attributes" do
    InterventionParticipant.create!(@valid_attributes)
  end
end
