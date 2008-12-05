require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Country do
  it "should create a new instance given valid attributes" do
    Factory(:country)
  end
end
