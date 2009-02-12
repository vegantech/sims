# == Schema Information
# Schema version: 20090212222347
#
# Table name: tiers
#
#  id          :integer         not null, primary key
#  district_id :integer
#  title       :string(255)
#  position    :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Tier do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :position => "1"
    }
  end

  it "should create a new instance given valid attributes" do
    Tier.create!(@valid_attributes)
  end
end
