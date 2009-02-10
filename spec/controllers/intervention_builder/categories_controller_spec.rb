require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe InterventionBuilder::CategoriesController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"

  def mock_category(stubs={})
    @mock_category ||= mock_model(InterventionBuilder::Category, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all intervention_builder_categories as @intervention_builder_categories" do
      pending
      InterventionBuilder::Category.should_receive(:find).with(:all).and_return([mock_category])
      get :index
      assigns[:intervention_builder_categories].should == [mock_category]
    end

    describe "with mime type of xml" do
  
      it "should render all intervention_builder_categories as xml" do
      pending
        request.env["HTTP_ACCEPT"] = "application/xml"
        InterventionBuilder::Category.should_receive(:find).with(:all).and_return(categories = mock("Array of InterventionBuilder::Categories"))
        categories.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested category as @category" do
      pending
      InterventionBuilder::Category.should_receive(:find).with("37").and_return(mock_category)
      get :show, :id => "37"
      assigns[:category].should equal(mock_category)
    end
    
    describe "with mime type of xml" do

      it "should render the requested category as xml" do
      pending
        request.env["HTTP_ACCEPT"] = "application/xml"
        InterventionBuilder::Category.should_receive(:find).with("37").and_return(mock_category)
        mock_category.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new category as @category" do
      pending
      InterventionBuilder::Category.should_receive(:new).and_return(mock_category)
      get :new
      assigns[:category].should equal(mock_category)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested category as @category" do
      pending
      InterventionBuilder::Category.should_receive(:find).with("37").and_return(mock_category)
      get :edit, :id => "37"
      assigns[:category].should equal(mock_category)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created category as @category" do
      pending
        InterventionBuilder::Category.should_receive(:new).with({'these' => 'params'}).and_return(mock_category(:save => true))
        post :create, :category => {:these => 'params'}
        assigns(:category).should equal(mock_category)
      end

      it "should redirect to the created category" do
      pending
        InterventionBuilder::Category.stub!(:new).and_return(mock_category(:save => true))
        post :create, :category => {}
        response.should redirect_to(intervention_builder_category_url(mock_category))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved category as @category" do
      pending
        InterventionBuilder::Category.stub!(:new).with({'these' => 'params'}).and_return(mock_category(:save => false))
        post :create, :category => {:these => 'params'}
        assigns(:category).should equal(mock_category)
      end

      it "should re-render the 'new' template" do
      pending
        InterventionBuilder::Category.stub!(:new).and_return(mock_category(:save => false))
        post :create, :category => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested category" do
      pending
        InterventionBuilder::Category.should_receive(:find).with("37").and_return(mock_category)
        mock_category.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :category => {:these => 'params'}
      end

      it "should expose the requested category as @category" do
      pending
        InterventionBuilder::Category.stub!(:find).and_return(mock_category(:update_attributes => true))
        put :update, :id => "1"
        assigns(:category).should equal(mock_category)
      end

      it "should redirect to the category" do
      pending
        InterventionBuilder::Category.stub!(:find).and_return(mock_category(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(intervention_builder_category_url(mock_category))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested category" do
      pending
        InterventionBuilder::Category.should_receive(:find).with("37").and_return(mock_category)
        mock_category.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :category => {:these => 'params'}
      end

      it "should expose the category as @category" do
      pending
        InterventionBuilder::Category.stub!(:find).and_return(mock_category(:update_attributes => false))
        put :update, :id => "1"
        assigns(:category).should equal(mock_category)
      end

      it "should re-render the 'edit' template" do
      pending
        InterventionBuilder::Category.stub!(:find).and_return(mock_category(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested category" do
      pending
      InterventionBuilder::Category.should_receive(:find).with("37").and_return(mock_category)
      mock_category.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the intervention_builder_categories list" do
      pending
      InterventionBuilder::Category.stub!(:find).and_return(mock_category(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(intervention_builder_categories_url)
    end

  end

end
