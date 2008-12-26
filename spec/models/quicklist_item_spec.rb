require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe QuicklistItem do
  it "should create a new instance given valid attributes" do
    Factory(:quicklist_item)
  end
end
