# == Schema Information
# Schema version: 20081208201532
#
# Table name: probe_definition_benchmarks
#
#  id                  :integer         not null, primary key
#  probe_definition_id :integer
#  benchmark           :integer
#  grade_level         :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#

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

  it "should not be valid when benchmark is less than probe_definition's minimum_score" do
    pd=ProbeDefinition.new(:title=>'title', :description=>'desc', :minimum_score=>10)
    pdb=pd.probe_definition_benchmarks.build(:grade_level=>5, :benchmark=>5,:probe_definition=>pd)
    pdb.should_not be_valid
  end

  it "should be valid when benchmark is greater than probe_definition's minimum_score" do
    pd=ProbeDefinition.new(:title=>'title', :description=>'desc', :minimum_score=>10)
    pdb=pd.probe_definition_benchmarks.build(:grade_level=>5, :benchmark=>15,:probe_definition=>pd)
    pdb.should be_valid
  end


  
end
