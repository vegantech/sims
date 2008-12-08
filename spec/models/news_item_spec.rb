require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NewsItem do
  before(:each) do
    @valid_attributes = {
      :text => "value for text",
      :system => true,
    }
  end

  it "should create a new instance given valid attributes" do
    NewsItem.create!(@valid_attributes)
  end
end
