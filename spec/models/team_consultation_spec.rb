# == Schema Information
# Schema version: 20090623023153
#
# Table name: team_consultations
#
#  id           :integer(4)      not null, primary key
#  student_id   :integer(4)
#  requestor_id :integer(4)
#  recipient_id :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TeamConsultation do
  before(:each) do
    @valid_attributes = {
    }
  end

  it "should create a new instance given valid attributes" do
    TeamConsultation.create!(@valid_attributes)
  end
end
