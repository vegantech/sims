require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CustomInterventionsController do
  it_should_behave_like "an authorized controller"
  include_context "authorized"
  include_context "authenticated"

 

  before do
    pending
    @student = mock_student
    @intervention_definition = mock_intervention_definition(:recommended_monitors_with_custom => [1,3,2])
    @intervention = mock_intervention(:student => @student, :comments => [], :intervention_probe_assignments=>[1],
    :intervention_definition => @intervention_definition, :title=>"mock_title")
    controller.stub_association!(:current_school, :assigned_users=>[])

    @interventions = [@intervention]
    @interventions.should_receive(:find).with(@intervention.id.to_s).any_number_of_times.and_return(@intervention)
    @student.stub!(:interventions=>@interventions)
    controller.stub!(:current_student=>@student)
    # build_from_session_and_params and populate_dropdowns are unit tested
    controller.stub!(:build_from_session_and_params=>@intervention)
    controller.stub_association!(:current_district, :tiers=>[mock_tier])
  end

  it 'should have specs for new, create, and the private methods'
end
