# == Schema Information
# Schema version: 20090524185436
#
# Table name: team_consultations
#
#  id           :integer         not null, primary key
#  student_id   :integer
#  requestor_id :integer
#  recipient_id :integer
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
