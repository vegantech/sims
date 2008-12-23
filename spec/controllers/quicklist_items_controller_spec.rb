require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe QuicklistItemsController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"

  def mock_quicklist_item(stubs={})
    @mock_quicklist_item ||= mock_model(QuicklistItem, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all quicklist_items as @quicklist_items" do
      QuicklistItem.should_receive(:find).with(:all).and_return([mock_quicklist_item])
      get :index
      assigns[:quicklist_items].should == [mock_quicklist_item]
    end

    describe "with mime type of xml" do
  
      it "should render all quicklist_items as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        QuicklistItem.should_receive(:find).with(:all).and_return(quicklist_items = mock("Array of QuicklistItems"))
        quicklist_items.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested quicklist_item as @quicklist_item" do
      QuicklistItem.should_receive(:find).with("37").and_return(mock_quicklist_item)
      get :show, :id => "37"
      assigns[:quicklist_item].should equal(mock_quicklist_item)
    end
    
    describe "with mime type of xml" do

      it "should render the requested quicklist_item as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        QuicklistItem.should_receive(:find).with("37").and_return(mock_quicklist_item)
        mock_quicklist_item.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new quicklist_item as @quicklist_item" do
      QuicklistItem.should_receive(:new).and_return(mock_quicklist_item)
      get :new
      assigns[:quicklist_item].should equal(mock_quicklist_item)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested quicklist_item as @quicklist_item" do
      QuicklistItem.should_receive(:find).with("37").and_return(mock_quicklist_item)
      get :edit, :id => "37"
      assigns[:quicklist_item].should equal(mock_quicklist_item)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created quicklist_item as @quicklist_item" do
        QuicklistItem.should_receive(:new).with({'these' => 'params'}).and_return(mock_quicklist_item(:save => true))
        post :create, :quicklist_item => {:these => 'params'}
        assigns(:quicklist_item).should equal(mock_quicklist_item)
      end

      it "should redirect to the created quicklist_item" do
        QuicklistItem.stub!(:new).and_return(mock_quicklist_item(:save => true))
        post :create, :quicklist_item => {}
        response.should redirect_to(quicklist_item_url(mock_quicklist_item))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved quicklist_item as @quicklist_item" do
        QuicklistItem.stub!(:new).with({'these' => 'params'}).and_return(mock_quicklist_item(:save => false))
        post :create, :quicklist_item => {:these => 'params'}
        assigns(:quicklist_item).should equal(mock_quicklist_item)
      end

      it "should re-render the 'new' template" do
        QuicklistItem.stub!(:new).and_return(mock_quicklist_item(:save => false))
        post :create, :quicklist_item => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested quicklist_item" do
        QuicklistItem.should_receive(:find).with("37").and_return(mock_quicklist_item)
        mock_quicklist_item.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :quicklist_item => {:these => 'params'}
      end

      it "should expose the requested quicklist_item as @quicklist_item" do
        QuicklistItem.stub!(:find).and_return(mock_quicklist_item(:update_attributes => true))
        put :update, :id => "1"
        assigns(:quicklist_item).should equal(mock_quicklist_item)
      end

      it "should redirect to the quicklist_item" do
        QuicklistItem.stub!(:find).and_return(mock_quicklist_item(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(quicklist_item_url(mock_quicklist_item))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested quicklist_item" do
        QuicklistItem.should_receive(:find).with("37").and_return(mock_quicklist_item)
        mock_quicklist_item.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :quicklist_item => {:these => 'params'}
      end

      it "should expose the quicklist_item as @quicklist_item" do
        QuicklistItem.stub!(:find).and_return(mock_quicklist_item(:update_attributes => false))
        put :update, :id => "1"
        assigns(:quicklist_item).should equal(mock_quicklist_item)
      end

      it "should re-render the 'edit' template" do
        QuicklistItem.stub!(:find).and_return(mock_quicklist_item(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested quicklist_item" do
      QuicklistItem.should_receive(:find).with("37").and_return(mock_quicklist_item)
      mock_quicklist_item.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the quicklist_items list" do
      QuicklistItem.stub!(:find).and_return(mock_quicklist_item(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(quicklist_items_url)
    end

  end

end
