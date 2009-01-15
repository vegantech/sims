require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe District::FlagCategoriesController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"

  def mock_flag_category(stubs={})
    @mock_flag_category ||= mock_model(FlagCategory, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all district_flag_categories as @district_flag_categories" do
      FlagCategory.should_receive(:find).with(:all).and_return([mock_flag_category])
      get :index
      assigns[:district_flag_categories].should == [mock_flag_category]
    end

    describe "with mime type of xml" do
  
      it "should render all district_flag_categories as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        FlagCategory.should_receive(:find).with(:all).and_return(flag_categories = mock("Array of FlagCategories"))
        flag_categories.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested flag_category as @flag_category" do
      FlagCategory.should_receive(:find).with("37").and_return(mock_flag_category)
      get :show, :id => "37"
      assigns[:flag_category].should equal(mock_flag_category)
    end
    
    describe "with mime type of xml" do

      it "should render the requested flag_category as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        FlagCategory.should_receive(:find).with("37").and_return(mock_flag_category)
        mock_flag_category.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new flag_category as @flag_category" do
      FlagCategory.should_receive(:new).and_return(mock_flag_category)
      get :new
      assigns[:flag_category].should equal(mock_flag_category)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested flag_category as @flag_category" do
      FlagCategory.should_receive(:find).with("37").and_return(mock_flag_category)
      get :edit, :id => "37"
      assigns[:flag_category].should equal(mock_flag_category)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created flag_category as @flag_category" do
        FlagCategory.should_receive(:new).with({'these' => 'params'}).and_return(mock_flag_category(:save => true))
        post :create, :flag_category => {:these => 'params'}
        assigns(:flag_category).should equal(mock_flag_category)
      end

      it "should redirect to the created flag_category" do
        pending
        FlagCategory.stub!(:new).and_return(mock_flag_category(:save => true))
        post :create, :flag_category => {}
        response.should redirect_to(mock_flag_category)
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved flag_category as @flag_category" do
        FlagCategory.stub!(:new).with({'these' => 'params'}).and_return(mock_flag_category(:save => false))
        post :create, :flag_category => {:these => 'params'}
        assigns(:flag_category).should equal(mock_flag_category)
      end

      it "should re-render the 'new' template" do
        FlagCategory.stub!(:new).and_return(mock_flag_category(:save => false))
        post :create, :flag_category => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested flag_category" do
        FlagCategory.should_receive(:find).with("37").and_return(mock_flag_category)
        mock_flag_category.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :flag_category => {:these => 'params'}
      end

      it "should expose the requested flag_category as @flag_category" do
        FlagCategory.stub!(:find).and_return(mock_flag_category(:update_attributes => true))
        put :update, :id => "1"
        assigns(:flag_category).should equal(mock_flag_category)
      end

      it "should redirect to the flag_category" do
        pending
        FlagCategory.stub!(:find).and_return(mock_flag_category(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(mock_flag_category)
      end

    end
    
    describe "with invalid params" do

      it "should update the requested flag_category" do
        FlagCategory.should_receive(:find).with("37").and_return(mock_flag_category)
        mock_flag_category.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :flag_category => {:these => 'params'}
      end

      it "should expose the flag_category as @flag_category" do
        FlagCategory.stub!(:find).and_return(mock_flag_category(:update_attributes => false))
        put :update, :id => "1"
        assigns(:flag_category).should equal(mock_flag_category)
      end

      it "should re-render the 'edit' template" do
        FlagCategory.stub!(:find).and_return(mock_flag_category(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested flag_category" do
      FlagCategory.should_receive(:find).with("37").and_return(mock_flag_category)
      mock_flag_category.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the district_flag_categories list" do
      FlagCategory.stub!(:find).and_return(mock_flag_category(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(flag_categories_url)
    end

  end

end
