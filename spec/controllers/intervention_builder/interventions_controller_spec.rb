require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe InterventionBuilder::InterventionsController do
  it_should_behave_like "an authorized controller"
  include_context "authorized"
  include_context "authenticated"

  def mock_intervention(stubs={})
    @mock_intervention ||= mock_model(Intervention, stubs)
  end

  before do
    @intervention_definition = mock_intervention_definition
    @intervention_cluster = mock_intervention_cluster(:intervention_definitions=>@intervention_definition)
    @intervention_cluster.stub!(:find => @intervention_cluster)
    @objective_definition = mock_objective_definition(:intervention_clusters=>@intervention_cluster)
    @objective_definition.stub!(:find => @objective_definition)
    @goal_definition = mock_goal_definition(:objective_definitions => @objective_definition)
    @goal_definition.stub!(:find => @goal_definition)
    controller.stub_association!(:current_district,:goal_definitions => @goal_definition, :intervention_clusters=>[1,2,3],
                                                   :tiers=>[mock_tier])
  end

  describe "responding to GET index" do

    it "should expose all intervention_builder_interventions as @intervention_builder_interventions" do
      @intervention_definition.stub!(:filter => @intervention_definition)
      get :index, :commit => 'true'
      assigns(:intervention_definitions).should == @intervention_definition
    end

  end

  describe "responding to GET show" do

    it "should expose the requested intervention as @intervention" do
      @intervention_definition.should_receive(:find).with("37").and_return(mock_intervention)
      get :show, :id => "37"
      assigns(:intervention_definition).should equal(mock_intervention)
    end
  end

  describe "responding to GET new" do

    it "should expose a new intervention as @intervention" do
      @intervention_definition.should_receive(:build).and_return(mock_intervention)
      mock_intervention.stub_association!(:assets,:build=>true)
      get :new
      assigns(:intervention_definition).should equal(mock_intervention)
    end

  end

  describe "responding to GET edit" do

    it "should expose the requested intervention as @intervention" do

      @intervention_definition.should_receive(:find).with("37").and_return(mock_intervention)
      get :edit, :id => "37"
      assigns(:intervention_definition).should equal(mock_intervention)
      assigns(:intervention_clusters).should == [1,2,3]
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do

      it "should expose a newly created intervention as @intervention_definition" do
        @intervention_definition.should_receive(:build).with('these' => 'params').and_return(mock_intervention(:save => true))
        post :create, :intervention_definition => {:these => 'params'}
        assigns(:intervention_definition).should equal(mock_intervention)
      end

      it "should redirect to the created intervention" do
        @intervention_definition.stub!(:build).and_return(mock_intervention(:save => true))
        post :create, :intervention_definition => {}
        response.should redirect_to(intervention_builder_interventions_url(@goal_definition,@objective_definition,@intervention_cluster))
      end

    end

    describe "with invalid params" do

      it "should expose a newly created but unsaved intervention as @intervention_definition" do
        @intervention_definition.stub!(:build).and_return(mock_intervention(:save => false))
        post :create, :intervention_definition => {:these => 'params'}
        assigns(:intervention_definition).should equal(mock_intervention)
      end

      it "should re-render the 'new' template" do
        @intervention_definition.stub!(:build).and_return(mock_intervention(:save => false))
        post :create, :intervention_definition => {}
        response.should render_template('new')
      end

    end

  end

  describe "responding to PUT update" do

    describe "with valid params" do
      before do
        @intervention_definition.should_receive(:find).with("37").and_return(@intervention_definition=mock_intervention_definition(:save=>true,:attributes= =>true, :intervention_cluster => @intervention_cluster))

      end

      it "should update the requested intervention" do
        @intervention_definition.should_receive(:attributes=).with("these" => 'params')
        put :update, :id => "37", :intervention_definition => {:these => 'params'}
      end

      it "should expose the requested intervention as @intervention_definition" do
        put :update, :id => "37"
        assigns(:intervention_definition).should equal(@intervention_definition)
      end

      it "should redirect to the intervention" do
        @intervention_definition.stub!(:find).and_return(mock_intervention(:attributes= => true))
        mock_intervention.stub!(:intervention_cluster=>@intervention_cluster)
        put :update, :id => "37"
        response.should redirect_to(intervention_builder_interventions_url(@goal_definition,@objective_definition,@intervention_cluster))
      end

    end

    describe "with invalid params" do
      before do
        @intervention_definition.should_receive(:find).with("37").and_return(@intervention_definition=mock_intervention_definition(:save=>false,:attributes= =>true, :intervention_cluster => @intervention_cluster))
      end


      it "should update the requested intervention" do
        @intervention_definition.should_receive(:attributes=).with('these' => 'params')
        put :update, :id => "37", :intervention_definition => {:these => 'params'}
      end

      it "should expose the intervention as @intervention" do
        put :update, :id => "37"
        assigns(:intervention_definition).should equal(@intervention_definition)
      end

      it "should re-render the 'edit' template" do
        put :update, :id => "37"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested intervention if there are no interventions" do
      @intervention_definition.should_receive(:find).with("37").and_return(@intervention_definition)
      @intervention_definition.should_receive(:destroy)
      @intervention_definition.stub_association!(:interventions,'any?'=>false)
      delete :destroy, :id => "37"
    end

    it "should redirect to the intervention_builder_interventions list" do
      @intervention_definition.stub!(:find).and_return(mock_intervention(:destroy => true))
      mock_intervention.stub_association!(:interventions,'any?'=>true)
      delete :destroy, :id => "1"
      flash[:notice].should == "Interventions exist for this intervention definition"
      response.should redirect_to(intervention_builder_interventions_url(@goal_definition,@objective_definition,@intervention_cluster))
    end

  end

end
