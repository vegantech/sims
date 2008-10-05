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
end
