require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProbeDefinitionBenchmark do
  before(:each) do
    @valid_attributes = {
      :benchmark => "1",
      :grade_level => "1"
    }
  end

  it "should create a new instance given valid attributes" do
    ProbeDefinitionBenchmark.create!(@valid_attributes)
  end
end
