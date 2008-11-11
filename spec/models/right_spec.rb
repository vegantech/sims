require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Right do
  before(:each) do
    @valid_attributes = {
      :controller => "students",
      :read => true,
      :write => false,
    }
  end

  it "should create a new instance given valid attributes" do
    Right.create!(@valid_attributes)
  end

  it "should not be valid given a nonexistant controller" do
    right= Right.new(@valid_attributes.merge(:controller=>"NOTThere"))
    right.should have(1).error_on(:controller)
  end
  
end
