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
