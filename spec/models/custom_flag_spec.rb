# == Schema Information
# Schema version: 20101101011500
#
# Table name: flags
#
#  id         :integer(4)      not null, primary key
#  category   :string(255)
#  user_id    :integer(4)
#  student_id :integer(4)
#  reason     :text
#  type       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CustomFlag do
  before(:each) do
    @valid_attributes = {
      category: "attendance",
      reason: "value for reason",
    }
  end

  it "should create a new instance given valid attributes" do
    CustomFlag.create!(@valid_attributes)
  end

  def test_do_not_allow_ignore_flag_when_ignore_exists
    a=IgnoreFlag.new(@valid_attributes)
    a.category="suspension"
    a.user_id=55
    a.save
    b=CustomFlag.new(a.attributes)
    a.should be_valid
    b.should_not be_valid
  end
end
