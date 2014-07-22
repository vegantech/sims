require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe InterventionBuilder::ObjectivesController do
  it_should_behave_like "an authorized controller"
  include_context "authorized"
  include_context "authenticated"

  def mock_objective(stubs={})
    @mock_objective ||= mock_model(ObjectiveDefinition, stubs)
  end

  before do
    @district=mock_district
    controller.stub_association!(:current_district, :goal_definitions=>GoalDefinition)
    @goal_definition = mock_goal_definition(:objective_definitions=>ObjectiveDefinition)
    GoalDefinition.should_receive(:find).with("44").any_number_of_times.and_return(@goal_definition)
  end

  describe "responding to GET index" do
    it "should expose objective_definitions as @objective_definitions" do
      @goal_definition.should_receive(:objective_definitions).and_return([mock_objective])
      get :index, :goal_id=>"44"
      assigns(:objective_definitions).should == [mock_objective]
    end

  end

  describe "responding to GET show" do

    it "should expose the requested objective as @objective_definition" do
      ObjectiveDefinition.should_receive(:find).with("37").and_return(mock_objective)
      get :show, :goal_id => "44", :id=>"37"
      assigns(:objective_definition).should equal(mock_objective)
    end

  end

  describe "responding to GET new" do

    it "should expose a new Objective as @objective_definition" do
      ObjectiveDefinition.should_receive(:build).and_return(mock_objective)
      get :new, :goal_id => "44"
      assigns(:objective_definition).should equal(mock_objective)
    end

  end

  describe "responding to GET edit" do
    it "should expose the requested objective as @objective_definition" do
      ObjectiveDefinition.should_receive(:find).with("37").and_return(mock_objective)
      get :edit, :id => "37", :goal_id=> "44"
      assigns(:objective_definition).should equal(mock_objective)
    end
  end

  describe "responding to POST create" do

    describe "with valid params" do

      it "should expose a newly created objective as @objective_definition" do
        ObjectiveDefinition.should_receive(:build).with('these' => 'params').and_return(mock_objective(:save => true))
        post :create, :objective_definition => {:these => 'params'}, :goal_id=>"44"
        assigns(:objective_definition).should equal(mock_objective)
      end

      it "should redirect to the created objective_definition" do
        ObjectiveDefinition.stub!(:build).and_return(mock_objective(:save => true))
        post :create, :objective => {}, :goal_id=>"44"
        response.should redirect_to(intervention_builder_objectives_url)
      end

    end

    describe "with invalid params" do

      it "should expose a newly created but unsaved objective as @objective_definition" do
        ObjectiveDefinition.stub!(:build).with('these' => 'params').and_return(mock_objective(:save => false))
        post :create, :objective_definition => {:these => 'params'}, :goal_id=>"44"
        assigns(:objective_definition).should equal(mock_objective)
      end

      it "should re-render the 'new' template" do
        ObjectiveDefinition.stub!(:build).and_return(mock_objective(:save => false))
        post :create, :objective_definition => {}, :goal_id=>"44"
        response.should render_template('new')
      end

    end

  end

  describe "responding to PUT update" do

    describe "with valid params" do

      it "should update the requested objective_definition" do
        ObjectiveDefinition.should_receive(:find).with("37").and_return(mock_objective(:save=>true))
        mock_objective.should_receive(:attributes=).with('these' => 'params')
        put :update, :id => "37", :objective_definition => {:these => 'params'}, :goal_id=>"44"
      end

      it "should expose the requested objective as @objective_definition" do
        ObjectiveDefinition.stub!(:find).and_return(mock_objective(:attributes= => true, :save=>true))
        put :update, :id => "1", :goal_id=>"44"
        assigns(:objective_definition).should equal(mock_objective)
      end

      it "should redirect to the objective" do
        ObjectiveDefinition.stub!(:find).and_return(mock_objective(:attributes= => true, :save=>true))
        put :update, :id => "1", :goal_id=>"44"
        response.should redirect_to(intervention_builder_objectives_url)
      end

    end

    describe "with invalid params" do

      it "should update the requested objective" do
        ObjectiveDefinition.should_receive(:find).with("37").and_return(mock_objective(:save=>false))
        mock_objective.should_receive(:attributes=).with('these' => 'params')
        put :update, :id => "37", :objective_definition => {:these => 'params'}, :goal_id=>"44"
      end

      it "should expose the objective as @objective_definition" do
        ObjectiveDefinition.stub!(:find).and_return(mock_objective(:attributes= => false,:save=>false))
        put :update, :id => "1", :goal_id=>"44"
        assigns(:objective_definition).should equal(mock_objective)
      end

      it "should re-render the 'edit' template" do
        ObjectiveDefinition.stub!(:find).and_return(mock_objective(:attributes= => false,:save=>false))
        put :update, :id => "1", :goal_id=>"44"
        response.should render_template('edit')
      end

    end

  end

end
=begin


  describe "responding to DELETE destroy" do
    describe 'when there are no objective definitions' do
      before do
        mock_goal.should_receive(:objective_definitions).and_return([])
      end

      it "should destroy the requested goal when there are no objective definitions and redirect" do
        GoalDefinition.should_receive(:find).with("37").and_return(mock_goal)
        
        mock_goal.should_receive(:destroy)
        delete :destroy, :id => "37"
        response.should redirect_to(intervention_builder_goals_url)
      end
    
   end

  end

end
=end
