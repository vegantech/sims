require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe InterventionBuilder::CategoriesController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"

  def mock_category(stubs={})
    @mock_category ||= mock_model(InterventionCluster, stubs)
  end
  before do
    @intervention_cluster = mock_intervention_cluster
    @intervention_cluster.stub!(:find => @intervention_cluster)
    @objective_definition = mock_objective_definition(:intervention_clusters=>InterventionCluster)
    @objective_definition.stub!(:find => @objective_definition)
    @goal_definition = mock_goal_definition(:objective_definitions => @objective_definition)
    @goal_definition.stub!(:find => @goal_definition)
    controller.stub_association!(:current_district,:goal_definitions => @goal_definition)
  end
 
  
  describe "responding to GET index" do

    it "should expose all intervention_builder_categories as @intervention_builder_categories" do
      InterventionCluster.should_receive(:find).with(:all).and_return([mock_category])
      get :index
      assigns[:intervention_clusters].should == [mock_category]
    end

  end

  describe "responding to GET show" do

    it "should expose the requested category as @intervention_cluster" do
      InterventionCluster.should_receive(:find).with("37").and_return(mock_category)
      get :show, :id => "37"
      assigns[:intervention_cluster].should equal(mock_category)
    end
    
   
  end

  describe "responding to GET new" do
  
    it "should expose a new category as @intervention_cluster" do
      InterventionCluster.should_receive(:build).and_return(mock_category)
      get :new
      assigns[:intervention_cluster].should equal(mock_category)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested category as @intervention_cluster" do
      InterventionCluster.should_receive(:find).with("37").and_return(mock_category)
      get :edit, :id => "37"
      assigns[:intervention_cluster].should equal(mock_category)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created category as @intervention_cluster" do
        InterventionCluster.should_receive(:build).with({'these' => 'params'}).and_return(mock_category(:save => true))
        post :create, :intervention_cluster => {:these => 'params'}
        assigns(:intervention_cluster).should equal(mock_category)
      end

      it "should redirect to the index" do
        InterventionCluster.stub!(:build).and_return(mock_category(:save => true))
        post :create, :intervention_cluster => {}
        response.should redirect_to(intervention_builder_categories_url(@goal_definition,@objective_definition))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved category as @intervention_cluster" do
        InterventionCluster.stub!(:build).with({'these' => 'params'}).and_return(mock_category(:save => false))
        post :create, :intervention_cluster => {:these => 'params'}
        assigns(:intervention_cluster).should equal(mock_category)
      end

      it "should re-render the 'new' template" do
        InterventionCluster.stub!(:build).and_return(mock_category(:save => false))
        post :create, :intervention_cluster => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested category" do
        InterventionCluster.should_receive(:find).with("37").and_return(mock_category)
        mock_category.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :intervention_cluster => {:these => 'params'}
      end

      it "should expose the requested category as @intervention_cluster" do
        InterventionCluster.stub!(:find).and_return(mock_category(:update_attributes => true))
        put :update, :id => "1"
        assigns(:intervention_cluster).should equal(mock_category)
      end

      it "should redirect to the category" do
        InterventionCluster.stub!(:find).and_return(mock_category(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(intervention_builder_categories_url(@goal_definition,@objective_definition))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested category" do
        InterventionCluster.should_receive(:find).with("37").and_return(mock_category)
        mock_category.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :intervention_cluster => {:these => 'params'}
      end

      it "should expose the category as @intervention_cluster" do
        InterventionCluster.stub!(:find).and_return(mock_category(:update_attributes => false))
        put :update, :id => "1"
        assigns(:intervention_cluster).should equal(mock_category)
      end

      it "should re-render the 'edit' template" do
        InterventionCluster.stub!(:find).and_return(mock_category(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested category" do
      InterventionCluster.should_receive(:find).with("37").and_return(mock_category(:intervention_definitions=>[]))
      mock_category.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the intervention_builder_categories list" do
      InterventionCluster.stub!(:find).and_return(mock_category(:destroy => true, :intervention_definitions=>[]))
      delete :destroy, :id => "1"
      response.should redirect_to(intervention_builder_categories_url(@goal_definition,@objective_definition))
    end

  end

end
