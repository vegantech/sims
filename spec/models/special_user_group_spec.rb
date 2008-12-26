# == Schema Information
# Schema version: 20081223233819
#
# Table name: special_user_groups
#
#  id           :integer         not null, primary key
#  user_id      :integer
#  district_id  :integer
#  school_id    :integer
#  grouptype    :integer
#  grade        :string(255)
#  integer      :string(255)
#  is_principal :boolean
#  created_at   :datetime
#  updated_at   :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SpecialUserGroup do
  before(:each) do
    @valid_attributes = {
      :grade => "value for grade",
      :type => "value for type",
      :is_principal => false,
      :grouptype=>1,
      :user_id=>1,
      :school_id=>2
    }
  end

  it "should create a new instance given valid attributes" do
    SpecialUserGroup.create!(@valid_attributes)
  end
end
