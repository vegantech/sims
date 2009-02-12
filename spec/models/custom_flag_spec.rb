# == Schema Information
# Schema version: 20090212222347
#
# Table name: flags
#
#  id          :integer         not null, primary key
#  category    :string(255)
#  user_id     :integer
#  district_id :integer
#  student_id  :integer
#  reason      :text
#  type        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CustomFlag do
  before(:each) do
    @valid_attributes = {
      :category => "attendance",
      :reason => "value for reason",
      :type => "value for type"
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
