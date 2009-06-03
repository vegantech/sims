# == Schema Information
# Schema version: 20090524185436
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
require 'test/unit'

describe IgnoreFlag do
  before(:each) do
    @valid_attributes = {
      :category => "attendance",
      :reason => "value for reason",
      :type => "value for type"
    }
  end

  it "should create a new instance given valid attributes" do
    IgnoreFlag.create!(@valid_attributes)
  end

  def test_invalid_with_empty_attributes
    flag = IgnoreFlag.new
    flag.should_not be_valid
    flag.errors_on(:category).should_not be_nil
  end

  def test_only_allow_one_ignore_flag
    IgnoreFlag.create!(@valid_attributes)
    a=IgnoreFlag.create(@valid_attributes)
    a.errors_on(:category).should_not be_nil
    a.category="suspension"
    a.should be_valid
  end

  def test_do_not_allow_ignore_flag_when_custom_exists
    a=CustomFlag.new(@valid_attributes)
    a.category="suspension"
    a.user_id=55
    a.save
    b=IgnoreFlag.new(a.attributes)
    a.should be_valid
    b.should_not be_valid
  end



  
end
