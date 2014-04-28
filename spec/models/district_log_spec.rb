# == Schema Information
# Schema version: 20101101011500
#
# Table name: district_logs
#
#  id          :integer(4)      not null, primary key
#  district_id :integer(4)
#  body        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DistrictLog do
  before(:each) do
    @valid_attributes = {
      :body => "value for body"
    }
  end

  it "should create a new instance given valid attributes" do
    DistrictLog.create!(@valid_attributes)
  end

  describe 'for_display' do
    it 'should have tests'
  end
end
