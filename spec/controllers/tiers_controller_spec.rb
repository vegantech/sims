require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TiersController do

  def mock_tier(stubs={})
    @mock_tier ||= mock_model(Tier, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all tiers as @tiers" do
      Tier.should_receive(:find).with(:all).and_return([mock_tier])
      get :index
      assigns[:tiers].should == [mock_tier]
    end

    describe "with mime type of xml" do
  
      it "should render all tiers as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Tier.should_receive(:find).with(:all).and_return(tiers = mock("Array of Tiers"))
        tiers.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested tier as @tier" do
      Tier.should_receive(:find).with("37").and_return(mock_tier)
      get :show, :id => "37"
      assigns[:tier].should equal(mock_tier)
    end
    
    describe "with mime type of xml" do

      it "should render the requested tier as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Tier.should_receive(:find).with("37").and_return(mock_tier)
        mock_tier.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new tier as @tier" do
      Tier.should_receive(:new).and_return(mock_tier)
      get :new
      assigns[:tier].should equal(mock_tier)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested tier as @tier" do
      Tier.should_receive(:find).with("37").and_return(mock_tier)
      get :edit, :id => "37"
      assigns[:tier].should equal(mock_tier)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created tier as @tier" do
        Tier.should_receive(:new).with({'these' => 'params'}).and_return(mock_tier(:save => true))
        post :create, :tier => {:these => 'params'}
        assigns(:tier).should equal(mock_tier)
      end

      it "should redirect to the created tier" do
        Tier.stub!(:new).and_return(mock_tier(:save => true))
        post :create, :tier => {}
        response.should redirect_to(tier_url(mock_tier))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved tier as @tier" do
        Tier.stub!(:new).with({'these' => 'params'}).and_return(mock_tier(:save => false))
        post :create, :tier => {:these => 'params'}
        assigns(:tier).should equal(mock_tier)
      end

      it "should re-render the 'new' template" do
        Tier.stub!(:new).and_return(mock_tier(:save => false))
        post :create, :tier => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested tier" do
        Tier.should_receive(:find).with("37").and_return(mock_tier)
        mock_tier.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :tier => {:these => 'params'}
      end

      it "should expose the requested tier as @tier" do
        Tier.stub!(:find).and_return(mock_tier(:update_attributes => true))
        put :update, :id => "1"
        assigns(:tier).should equal(mock_tier)
      end

      it "should redirect to the tier" do
        Tier.stub!(:find).and_return(mock_tier(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(tier_url(mock_tier))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested tier" do
        Tier.should_receive(:find).with("37").and_return(mock_tier)
        mock_tier.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :tier => {:these => 'params'}
      end

      it "should expose the tier as @tier" do
        Tier.stub!(:find).and_return(mock_tier(:update_attributes => false))
        put :update, :id => "1"
        assigns(:tier).should equal(mock_tier)
      end

      it "should re-render the 'edit' template" do
        Tier.stub!(:find).and_return(mock_tier(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested tier" do
      Tier.should_receive(:find).with("37").and_return(mock_tier)
      mock_tier.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the tiers list" do
      Tier.stub!(:find).and_return(mock_tier(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(tiers_url)
    end

  end

end
