require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InterventionDefinition do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :description => "value for description",
      :time_length_id =>1,
      :frequency_id =>1,
      :custom => false,
      :disabled => false,
      :position => "1"
    }
  end

  it "should create a new instance given valid attributes" do
    InterventionDefinition.create!(@valid_attributes)
  end
end
