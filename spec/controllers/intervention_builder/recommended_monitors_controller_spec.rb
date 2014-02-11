require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe InterventionBuilder::RecommendedMonitorsController do
  it_should_behave_like "an authorized controller"
  include_context "authorized"
  include_context "authenticated"


  #Delete this example and add some real ones
  it "should use InterventionBuilder::RecommendedMonitorsController" do
    controller.should be_an_instance_of(InterventionBuilder::RecommendedMonitorsController)
  end
  it 'should have real specs'

  describe "assign_probes_to_intervention_defnition" do
    it "should not allow duplicates" do
      intervention_definition = mock_intervention_definition(:ancestor_ids => [1,2,3,4])
      district = mock_district(:intervention_definitions => InterventionDefinition)
      InterventionDefinition.should_receive(:find).with("22").and_return(intervention_definition)
      controller.stub!(:current_district => district, :reset_intervention_menu => true )
      intervention_definition.should_receive(:probe_definition_ids=).with(["1","3","2","4"])
      post  :assign_probes_to_intervention, {:probes => ["1","1","3","1","1","2","1","4"], :id => "22", :commit => "yes"}
    end
  end
end
