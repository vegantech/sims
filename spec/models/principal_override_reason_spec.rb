# == Schema Information
# Schema version: 20101101011500
#
# Table name: principal_override_reasons
#
#  id          :integer(4)      not null, primary key
#  district_id :integer(4)
#  reason      :text
#  autopromote :boolean(1)
#  created_at  :datetime
#  updated_at  :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PrincipalOverrideReason do
  before(:each) do
    @valid_attributes = {
      reason: "value for reason",
      autopromote: false
    }
  end


  it "needs tests"
  it "should create a new instance given valid attributes" do
    PrincipalOverrideReason.create!(@valid_attributes)
  end
end
