# == Schema Information
# Schema version: 20090428193630
#
# Table name: time_lengths
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  days       :integer
#  created_at :datetime
#  updated_at :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TimeLength do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :days => "1"
    }
  end

  it "should create a new instance given valid attributes" do
    TimeLength.create!(@valid_attributes)
  end
end
