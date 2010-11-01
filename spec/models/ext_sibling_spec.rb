# == Schema Information
# Schema version: 20101101011500
#
# Table name: ext_siblings
#
#  id             :integer(4)      not null, primary key
#  student_id     :integer(4)
#  first_name     :string(255)
#  middle_name    :string(255)
#  last_name      :string(255)
#  student_number :string(255)
#  grade          :string(255)
#  school_name    :string(255)
#  age            :integer(4)
#  created_at     :datetime
#  updated_at     :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ExtSibling do
  before(:each) do
    @valid_attributes = {
      :first_name => "value for first_name",
      :middle_name => "value for middle_name",
      :last_name => "value for last_name",
      :student_number => "value for student_number",
      :grade => "value for grade",
      :school_name => "value for school_name",
      :age => 1
    }
  end

  it "should create a new instance given valid attributes" do
    ExtSibling.create!(@valid_attributes)
  end
end
