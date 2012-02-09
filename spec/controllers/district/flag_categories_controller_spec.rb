require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe District::FlagCategoriesController do
  it_should_behave_like "an authorized controller"
  include_context "authorized"
  include_context "authenticated"


  def mock_flag_category(stubs={})
    @mock_flag_category ||= mock_model(FlagCategory, stubs)
  end


  before do
    controller.stub_association!(:current_district,:flag_categories=>FlagCategory)
  end
  describe "responding to GET index" do

    it "should expose all district_flag_categories as @flag_categories" do
      FlagCategory.should_receive(:find).with(:all).and_return([mock_flag_category])
      controller.stub_association!(:current_district,:flag_categories=>FlagCategory.find(:all))
      get :index
      assigns(:flag_categories).should == [mock_flag_category]
    end
  end

  describe "responding to GET new" do
    it "should expose a new flag_category as @flag_category" do
      FlagCategory.should_receive(:build).and_return(mock_flag_category)
      mock_flag_category.stub_association!(:assets,:build=>{})
      get :new
      assigns(:flag_category).should equal(mock_flag_category)
    end

  end

  describe "responding to GET edit" do
    it "should expose the requested flag_category as @flag_category" do
      FlagCategory.should_receive(:find).with("37").and_return(mock_flag_category)
      get :edit, :id => "37"
      assigns(:flag_category).should equal(mock_flag_category)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      it "should expose a newly created flag_category as @flag_category" do
        FlagCategory.should_receive(:build).with({'these' => 'params'}).and_return(mock_flag_category(:save => true))
        post :create, :flag_category => {:these => 'params'}
        assigns(:flag_category).should equal(mock_flag_category)
      end

      it "should redirect to the created flag_category" do
        FlagCategory.stub!(:build).and_return(mock_flag_category(:save => true))
        post :create, :flag_category => {}
        response.should redirect_to(flag_categories_url)
      end
    end

    describe "with invalid params" do

      it "should expose a newly created but unsaved flag_category as @flag_category" do
        FlagCategory.stub!(:build).with({'these' => 'params'}).and_return(mock_flag_category(:save => false))
        post :create, :flag_category => {:these => 'params'}
        assigns(:flag_category).should equal(mock_flag_category)
      end

      it "should re-render the 'new' template" do
        FlagCategory.stub!(:build).and_return(mock_flag_category(:save => false))
        post :create, :flag_category => {}
        response.should render_template('new')
      end

    end

  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested flag_category" do
        FlagCategory.should_receive(:find).with("37").and_return(mock_flag_category)
        mock_flag_category.should_receive(:update_attributes).with({'these' => 'params', "existing_asset_attributes" => {}})
        put :update, :id => "37", :flag_category => {:these => 'params'}
      end

      it "should expose the requested flag_category as @flag_category" do
        FlagCategory.stub!(:find).and_return(mock_flag_category(:update_attributes => true))
        put :update, :id => "1", :flag_category => {:these => 'params'}
        assigns(:flag_category).should equal(mock_flag_category)
      end

      it "should redirect to the flag_category" do
        FlagCategory.stub!(:find).and_return(mock_flag_category(:update_attributes => true))
        put :update, :id => "1", :flag_category => {:these => 'params'}
        response.should redirect_to(flag_categories_url)
      end

    end

    describe "with invalid params" do

      it "should update the requested flag_category" do
        FlagCategory.should_receive(:find).with("37").and_return(mock_flag_category)
        mock_flag_category.should_receive(:update_attributes).with({'these' => 'params', "existing_asset_attributes" => {}})
        put :update, :id => "37", :flag_category => {:these => 'params'}
      end

      it "should expose the flag_category as @flag_category" do
        FlagCategory.stub!(:find).and_return(mock_flag_category(:update_attributes => false))
        put :update, :id => "1", :flag_category => {:these => 'params'}
        assigns(:flag_category).should equal(mock_flag_category)
      end

      it "should re-render the 'edit' template" do
        FlagCategory.stub!(:find).and_return(mock_flag_category(:update_attributes => false))
        put :update, :id => "1", :flag_category => {:these => 'params'}
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
