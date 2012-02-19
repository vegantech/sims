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

  it 'should be invalid with empty attributes' do
    flag = IgnoreFlag.new
    flag.should_not be_valid
    flag.errors_on(:category).should_not be_nil
  end

  it 'should only allow one ingore flag for a given category(/student)' do
    IgnoreFlag.create!(@valid_attributes)
    a=IgnoreFlag.create(@valid_attributes)
    a.errors_on(:category).should_not be_nil
    a.category="suspension"
    a.should be_valid
  end

  it 'should not allow ignore flag when custom exists' do
    a=CustomFlag.new(@valid_attributes)
    a.category="suspension"
    a.user_id=55
    a.save
    b=IgnoreFlag.new(a.attributes)
    a.should be_valid
    b.should_not be_valid
  end
end
