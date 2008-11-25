require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InterventionComment do
  before(:each) do
    @valid_attributes = {
      :comment => "value for comment",
    }
  end

  it "should create a new instance given valid attributes" do
    InterventionComment.create!(@valid_attributes)
  end
end
