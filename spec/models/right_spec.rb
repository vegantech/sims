require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


unless defined? AllControllers
  class AllControllers
    NAMES=['students']
  end
end

describe Right do
  before(:each) do
    @valid_attributes = {
      :controller => "students",
      :read_access => true,
      :write_access=> false,
    }
  end

  it "should not be valid given a nonexistant controller" do
    pending
    right= Right.new(@valid_attributes.merge(:controller=>"NOTThere"))
    

    right.should_not be_valid
    right.should have(1).error_on(:controller)
    
  end
  
end
