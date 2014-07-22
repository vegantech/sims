require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Interventions::QuicklistsController do
  it_should_behave_like "an authorized controller"
  include_context "authorized"
  include_context "authenticated"

  before do
    @district = mock_district(:intervention_definitions => InterventionDefinition)
    controller.stub!(:current_district => @district)
  end
  describe 'index' do
    it 'should return an empty array when school is nil' do
      #LH 462
      controller.stub!(:current_school=>nil)
      get :index
      assigns(:quicklist_intervention_definitions).should be_empty
    end

    it 'should return an array of interventions for a school' do
      disabled = mock_intervention_definition(:disabled => true)
      enabled = mock_intervention_definition(:disabled => false)
      school = mock_school(:quicklist => [disabled,enabled])
      controller.should_receive(:current_school).and_return(school)
      get :index
      assigns(:quicklist_intervention_definitions).should == [enabled]

    end

  end

  describe 'create' do
    it "should redirect to the new_intervention_url with that intervention_definition" do
      InterventionDefinition.should_receive(:find).with('1').and_return(
      mock_intervention_definition(:goal_definition_id => 1,
                                   :objective_definition_id => 2,
                                   :intervention_cluster_id => 3, :id =>1))
      post :create, :intervention_definition_id=> '1'
      response.should redirect_to(new_intervention_url(:goal_id => 1, :objective_id => 2, :category_id => 3, :definition_id =>1))
    end
  end
end
