require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ObjectiveDefinition do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :description => "value for description",
      :position => "1",
      :disabled => false
    }
  end

  it "should create a new instance given valid attributes" do
    ObjectiveDefinition.create!(@valid_attributes)
  end
end
