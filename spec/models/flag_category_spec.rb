# == Schema Information
# Schema version: 20090316004509
#
# Table name: flag_categories
#
#  id          :integer         not null, primary key
#  district_id :integer
#  category    :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  threshold   :integer         default(100)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FlagCategory do
  before(:each) do
    @valid_attributes = {
      :category => Flag::FLAGTYPES.keys[0]
    }
  end

  it "should create a new instance given valid attributes" do
    FlagCategory.create!(@valid_attributes)
  end
end
