require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InterventionParticipant do
  before(:each) do
    @valid_attributes = {
      :intervention => ,
      :user => ,
      :role => "1"
    }
  end

  it "should create a new instance given valid attributes" do
    InterventionParticipant.create!(@valid_attributes)
  end
end
