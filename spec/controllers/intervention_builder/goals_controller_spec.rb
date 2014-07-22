require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe InterventionBuilder::GoalsController do
  it_should_behave_like "an authorized controller"
  include_context "authorized"
  include_context "authenticated"

  def mock_goal(stubs={})
    @mock_goal ||= mock_model(GoalDefinition, stubs)
  end

  before do
    @district=mock_district
    controller.stub!(current_district: @district)
    @district.stub!(goal_definitions: GoalDefinition)
  end

  describe "responding to GET index" do
    before do
      @district.should_receive(:goal_definitions).and_return([mock_goal])

    end

    it "should expose all goal_definitions as @goal_definitions" do
      get :index
      assigns(:goal_definitions).should == [mock_goal]
    end

  end

  describe "responding to GET show" do

    it "should expose the requested goal as @goal_definition" do
      GoalDefinition.should_receive(:find).with("37").and_return(mock_goal)
      get :show, id: "37"
      assigns(:goal_definition).should equal(mock_goal)
    end

  end

  describe "responding to GET new" do

    it "should expose a new goal as @goal_definition" do
      @district.stub_association!(:goal_definitions,build: mock_goal)
      get :new
      assigns(:goal_definition).should equal(mock_goal)
    end

  end

  describe "responding to GET edit" do

    it "should expose the requested goal as @goal_definition" do
      GoalDefinition.should_receive(:find).with("37").and_return(mock_goal)
      get :edit, id: "37"
      assigns(:goal_definition).should equal(mock_goal)
    end

  end

  describe "responding to POST create" do
    before do
      @district.should_receive(:goal_definitions).and_return(GoalDefinition)

    end

    describe "with valid params" do

      it "should expose a newly created goal as @goal_definition" do
        GoalDefinition.should_receive(:build).with('these' => 'params').and_return(mock_goal(save: true))
        post :create, goal_definition: {these: 'params'}
        assigns(:goal_definition).should equal(mock_goal)
      end

      it "should redirect to the created goal_definition" do
        GoalDefinition.stub!(:build).and_return(mock_goal(save: true))
        post :create, goal: {}
        response.should redirect_to(intervention_builder_goals_url)
      end

    end

    describe "with invalid params" do

      it "should expose a newly created but unsaved goal as @goal_definition" do
        GoalDefinition.stub!(:build).with('these' => 'params').and_return(mock_goal(save: false))
        post :create, goal_definition: {these: 'params'}
        assigns(:goal_definition).should equal(mock_goal)
      end

      it "should re-render the 'new' template" do
        GoalDefinition.stub!(:build).and_return(mock_goal(save: false))
        post :create, goal_definition: {}
        response.should render_template('new')
      end

    end

  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested goal_definition" do
        GoalDefinition.should_receive(:find).with("37").and_return(mock_goal(save: true))
        mock_goal.should_receive(:attributes=).with('these' => 'params')
        put :update, id: "37", goal_definition: {these: 'params'}
      end

      it "should expose the requested goal as @goal_definition" do
        GoalDefinition.stub!(:find).and_return(mock_goal(:save => true, :attributes= =>true))
        put :update, id: "1"
        assigns(:goal_definition).should equal(mock_goal)
      end

      it "should redirect to the goal" do
        GoalDefinition.stub!(:find).and_return(mock_goal(:save => true, :attributes= => true))
        put :update, id: "1"
        response.should redirect_to(intervention_builder_goals_url)
      end

    end

    describe "with invalid params" do

      it "should update the requested goal" do
        GoalDefinition.should_receive(:find).with("37").and_return(mock_goal(save: false))
        mock_goal.should_receive(:attributes=).with('these' => 'params')
        put :update, id: "37", goal_definition: {these: 'params'}
      end

      it "should expose the goal as @goal_definition" do
        GoalDefinition.stub!(:find).and_return(mock_goal(:save =>false,:attributes= => false))
        put :update, id: "1"
        assigns(:goal_definition).should equal(mock_goal)
      end

      it "should re-render the 'edit' template" do
        GoalDefinition.stub!(:find).and_return(mock_goal(:save =>false,:attributes= => false))
        put :update, id: "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do
    describe 'when there are no objective definitions' do
      before do
        mock_goal.should_receive(:objective_definitions).and_return([])
      end

      it "should destroy the requested goal when there are no objective definitions and redirect" do
        GoalDefinition.should_receive(:find).with("37").and_return(mock_goal)

        mock_goal.should_receive(:destroy)
        delete :destroy, id: "37"
        response.should redirect_to(intervention_builder_goals_url)
      end

    end

  end

end
