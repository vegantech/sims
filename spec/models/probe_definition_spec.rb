require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProbeDefinition do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :description => "value for description",
      :active => false,
      :maximum_score => "1",
      :minimum_score => "1",
      :position => "1"
    }
  end

  it "should create a new instance given valid attributes" do
    ProbeDefinition.create!(@valid_attributes)
  end
end
