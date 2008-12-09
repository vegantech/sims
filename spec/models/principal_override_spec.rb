# == Schema Information
# Schema version: 20081208201532
#
# Table name: principal_overrides
#
#  id                 :integer         not null, primary key
#  teacher_id         :integer
#  student_id         :integer
#  principal_id       :integer
#  status             :integer
#  start_tier_id      :integer
#  end_tier_id        :integer
#  principal_response :string(1024)
#  teacher_request    :string(1024)
#  created_at         :datetime
#  updated_at         :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PrincipalOverride do
  before(:each) do
    @valid_attributes = {
      :status => 0,
      :teacher_request => "value for fufillment_reason",
      :student=>mock_student(:max_tier=>Tier.new(:title=>"TIER 1"), :principals=>[User.new], :fullname => "Test Student"),
      :teacher=>User.new
    }
  end

  it "should create a new instance given valid attributes" do
    PrincipalOverride.create!(@valid_attributes)
  end
end
