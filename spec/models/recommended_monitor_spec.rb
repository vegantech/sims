require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RecommendedMonitor do
  before(:each) do
    @valid_attributes = {
      :intervention_definition_id => 1,
      :probe_definition_id => 1,
      :note => "value for note",
      :position => "1"
    }
  end

  it "should create a new instance given valid attributes" do
    RecommendedMonitor.create!(@valid_attributes)
  end
end
