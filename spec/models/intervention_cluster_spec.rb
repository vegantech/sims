# == Schema Information
# Schema version: 20101101011500
#
# Table name: intervention_clusters
#
#  id                      :integer(4)      not null, primary key
#  title                   :string(255)
#  description             :text
#  objective_definition_id :integer(4)
#  position                :integer(4)
#  disabled                :boolean(1)
#  created_at              :datetime
#  updated_at              :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InterventionCluster do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :description => "value for description",
      :position => "1",
      :disabled => false
    }
  end

  it 'should have other tests'

  describe 'sld' do
    before do
      InterventionCluster.delete_all
      InterventionDefinition.delete_all
    end
    it 'should return a normal intervention cluster set' do
      f=Factory(:intervention_definition)
      ics=InterventionCluster.include_sld_criteria_from_definitions
      ics.should == [f.intervention_cluster]
      ics.first.should_not be_sld
    end


    it 'should return sld for intervention definitions with sld' do
      f=Factory(:intervention_definition, :sld_array => InterventionDefinition::SLD_CRITERIA[0..4], :mins_per_week=>1)
      g=Factory(:intervention_definition, :intervention_cluster_id => f.intervention_cluster_id, :sld_array =>  InterventionDefinition::SLD_CRITERIA[5..-1], :mins_per_week=>1)
      ics=InterventionCluster.include_sld_criteria_from_definitions
      ics.should == [f.intervention_cluster]
      ics.first.should be_sld
      ics.first.sld.should == 255
    end

  end


  it "should create a new instance given valid attributes" do
    InterventionCluster.create!(@valid_attributes)
  end
end
