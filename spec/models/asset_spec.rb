require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Asset do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :url => "value for url",
      #      :attachable => 
    }
  end

  it "should create a new instance given valid attributes" do
    Asset.create!(@valid_attributes)
  end
end
