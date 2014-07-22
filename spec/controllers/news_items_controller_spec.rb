require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NewsItemsController do
  it_should_behave_like "an authorized controller"
  include_context "authorized"
  include_context "authenticated"
  before do
    district=mock_district
    district.stub_association!(:administers,:news=>NewsItem)
    controller.stub!(:current_district).and_return(district)
  end



  def mock_news_item(stubs={})
    @mock_news_item ||= mock_model(NewsItem, stubs)
  end

  describe "responding to GET new" do

    it "should expose a new news_item as @news_item" do
      NewsItem.should_receive(:new).and_return(mock_news_item)
      get :new
      assigns(:news_item).should equal(mock_news_item)
    end

  end

  describe "responding to GET edit" do

    it "should expose the requested news_item as @news_item" do
      NewsItem.should_receive(:find).with("37").and_return(mock_news_item)
      get :edit, :id => "37"
      assigns(:news_item).should equal(mock_news_item)
    end

  end

  describe "responding to POST create" do
    describe "with valid params" do

      it "should expose a newly created news_item as @news_item" do
        NewsItem.should_receive(:build).with('these' => 'params').and_return(mock_news_item(:save => true))
        post :create, :news_item => {:these => 'params'}
        assigns(:news_item).should equal(mock_news_item)
      end

      it "should redirect to the created news_item" do
        NewsItem.stub!(:build).and_return(mock_news_item(:save => true))
        post :create, :news_item => {}
        response.should redirect_to(root_url)
      end

    end

    describe "with invalid params" do

      it "should expose a newly created but unsaved news_item as @news_item" do
        NewsItem.stub!(:build).with('these' => 'params').and_return(mock_news_item(:save => false))
        post :create, :news_item => {:these => 'params'}
        assigns(:news_item).should equal(mock_news_item)
      end

      it "should re-render the 'new' template" do
        NewsItem.stub!(:build).and_return(mock_news_item(:save => false))
        post :create, :news_item => {}
        response.should render_template('new')
      end

    end

  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested news_item" do
        NewsItem.should_receive(:find).with("37").and_return(mock_news_item(:save=>true))
        mock_news_item.should_receive(:attributes=).with('these' => 'params')
        put :update, :id => "37", :news_item => {:these => 'params'}
      end

      it "should expose the requested news_item as @news_item" do
        NewsItem.stub!(:find).and_return(mock_news_item(:save => true, :attributes= => false))
        put :update, :id => "1"
        assigns(:news_item).should equal(mock_news_item)
      end

      it "should redirect to the news_item" do
        NewsItem.stub!(:find).and_return(mock_news_item(:save => true, :attributes= => false))
        put :update, :id => "1"
        response.should redirect_to(root_url)
      end

    end

    describe "with invalid params" do

      it "should update the requested news_item" do
        NewsItem.should_receive(:find).with("37").and_return(mock_news_item(:save=>false))
        mock_news_item.should_receive(:attributes=).with('these' => 'params')
        put :update, :id => "37", :news_item => {:these => 'params'}
      end

      it "should expose the news_item as @news_item" do
        NewsItem.stub!(:find).and_return(mock_news_item(:save => false, :attributes= => false))
        put :update, :id => "1"
        assigns(:news_item).should equal(mock_news_item)
      end

      it "should re-render the 'edit' template" do
        NewsItem.stub!(:find).and_return(mock_news_item(:save => false, :attributes= => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested news_item" do
      NewsItem.should_receive(:find).with("37").and_return(mock_news_item)
      mock_news_item.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "should redirect to the news_items list" do
      NewsItem.stub!(:find).and_return(mock_news_item(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(root_url)
    end

  end

end
