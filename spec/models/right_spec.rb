require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Right do
  before(:each) do
    @valid_attributes = {
      :controller => "value for controller",
      :read => false,
      :write => false,
    }
  end

  it "should create a new instance given valid attributes" do
    Right.create!(@valid_attributes)
  end
end
