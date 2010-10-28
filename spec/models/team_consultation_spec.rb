# == Schema Information
# Schema version: 20101027022939
#
# Table name: team_consultations
#
#  id           :integer(4)      not null, primary key
#  student_id   :integer(4)
#  requestor_id :integer(4)
#  team_id      :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#  complete     :boolean(1)
#  draft        :boolean(1)
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

  describe 'recipients' do
    it 'should return an empty array when there is no school team' do
      #LH 463
      TeamConsultation.new.recipients.should be_empty

    end

    it 'should return an array of users when there is a school team' 

  end
end
