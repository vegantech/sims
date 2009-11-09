require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ExtArbitrary do
  before(:each) do
    @valid_attributes = {
      :content => "value for content"
    }
  end

  it "should create a new instance given valid attributes" do
    ExtArbitrary.create!(@valid_attributes)
  end
end
