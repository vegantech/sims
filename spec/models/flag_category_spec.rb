# == Schema Information
# Schema version: 20101101011500
#
# Table name: flag_categories
#
#  id          :integer(4)      not null, primary key
#  district_id :integer(4)
#  category    :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  threshold   :integer(4)      default(100)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FlagCategory do
  before(:each) do
    @valid_attributes = {
      category: Flag::FLAGTYPES.keys[0]
    }
  end

  it "should create a new instance given valid attributes" do
    FlagCategory.create!(@valid_attributes)
  end
end
