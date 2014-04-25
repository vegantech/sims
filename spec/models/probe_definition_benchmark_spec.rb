# == Schema Information
# Schema version: 20101101011500
#
# Table name: probe_definition_benchmarks
#
#  id                  :integer(4)      not null, primary key
#  probe_definition_id :integer(4)
#  benchmark           :integer(4)
#  grade_level         :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProbeDefinitionBenchmark do
  before(:each) do
    @valid_attributes = {
      benchmark: "1",
      grade_level: "1"
    }
  end

  it "should create a new instance given valid attributes" do
    ProbeDefinitionBenchmark.create!(@valid_attributes)
  end

  it "should not be valid when benchmark is less than probe_definition's minimum_score" do
    pd = ProbeDefinition.new(title: 'title', description: 'desc', minimum_score: 10)
    pdb = pd.probe_definition_benchmarks.build(grade_level: "5", benchmark: 5,probe_definition: pd)
    pdb.should_not be_valid
  end

  it "should be valid when benchmark is greater than probe_definition's minimum_score" do
    pd = ProbeDefinition.new(title: 'title', description: 'desc', minimum_score: 10)
    pdb = pd.probe_definition_benchmarks.build(grade_level: "5", benchmark: 15,probe_definition: pd)
    pdb.should be_valid
  end

  it 'should ignore blank probe definitions (previously #lh238) ' do 
    pd = ProbeDefinition.create!(title: 'title', description: 'desc', minimum_score: 10)
    pd.update_attributes(probe_definition_benchmarks_attributes: [benchmark: '', grade_level: '']).should == true
    pd.probe_definition_benchmarks.should be_blank
    pd.update_attributes(probe_definition_benchmarks_attributes: [benchmark: '19', grade_level: '']).should == false
    pd.update_attributes(probe_definition_benchmarks_attributes: [benchmark: '9', grade_level: '1']).should == false
  end


  
end
