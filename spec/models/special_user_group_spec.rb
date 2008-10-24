require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SpecialUserGroup do
  before(:each) do
    @valid_attributes = {
      :grade => "value for grade",
      :type => "value for type",
      :is_principal => false
    }
  end

  it "should create a new instance given valid attributes" do
    SpecialUserGroup.create!(@valid_attributes)
  end
end
