require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Answer do
  before(:each) do
    @valid_attributes = {
      :text => "value for text"
    }
  end

  it "should create a new instance given valid attributes" do
    pending 'No unit test either, need to test this in isolation from checklist'
    Answer.create!(@valid_attributes)
  end
end
