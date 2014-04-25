# == Schema Information
# Schema version: 20101101011500
#
# Table name: ext_arbitraries
#
#  id         :integer(4)      not null, primary key
#  student_id :integer(4)
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ExtArbitrary do
  before(:each) do
    @valid_attributes = {
      content: "value for content"
    }
  end

  it "should create a new instance given valid attributes" do
    ExtArbitrary.create!(@valid_attributes)
  end
end
