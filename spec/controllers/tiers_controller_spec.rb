require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TiersController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"
  


  def mock_tier(stubs={})
    @mock_tier ||= mock_model(Tier, stubs)
  end

  before do
    controller.stub!(:current_district=>mock_district(:tiers=>Tier))
  end

  
  describe "GET index" do
    it "assigns all tiers as @tiers" do
      Tier.should_receive(:find).with(:all).and_return([mock_tier])
      get :index
      assigns[:tiers].should == [mock_tier]
    end
  end

  describe "GET show" do
    it "assigns the requested tier as @tier" do
      Tier.should_receive(:find).with("37").and_return(mock_tier)
      get :show, :id => "37"
      assigns[:tier].should equal(mock_tier)
    end
  end

  describe "GET new" do
    it "assigns a new tier as @tier" do
      Tier.should_receive(:build).and_return(mock_tier)
      get :new
      assigns[:tier].should equal(mock_tier)
    end
  end

  describe "GET edit" do
    it "assigns the requested tier as @tier" do
      Tier.should_receive(:find).with("37").and_return(mock_tier)
      get :edit, :id => "37"
      assigns[:tier].should equal(mock_tier)
    end
  end

  describe "POST create" do
    
    describe "with valid params" do
      it "assigns a newly created tier as @tier" do
        Tier.should_receive(:build).with({'these' => 'params'}).and_return(mock_tier(:save => true))
        post :create, :tier => {:these => 'params'}
        assigns[:tier].should equal(mock_tier)
      end

      it "redirects to the created tier" do
        Tier.stub!(:build).and_return(mock_tier(:save => true))
        post :create, :tier => {}
        response.should redirect_to(tiers_url)
      end
    end
    
    describe "with invalid params" do
      it "assigns a newly created but unsaved tier as @tier" do
        Tier.stub!(:build).with({'these' => 'params'}).and_return(mock_tier(:save => false))
        post :create, :tier => {:these => 'params'}
        assigns[:tier].should equal(mock_tier)
      end

      it "re-renders the 'new' template" do
        Tier.stub!(:build).and_return(mock_tier(:save => false))
        post :create, :tier => {}
        response.should render_template('new')
      end
    end
    
  end

  describe "PUT udpate" do
    
    describe "with valid params" do
      it "updates the requested tier" do
        Tier.should_receive(:find).with("37").and_return(mock_tier(:save => true))
        mock_tier.should_receive(:attributes=).with({'these' => 'params'})
        put :update, :id => "37", :tier => {:these => 'params'}
      end

      it "assigns the requested tier as @tier" do
        Tier.stub!(:find).and_return(mock_tier(:attributes= => true, :save => true))
        put :update, :id => "1"
        assigns[:tier].should equal(mock_tier)
      end

      it "redirects to the tiers" do
        Tier.stub!(:find).and_return(mock_tier(:attributes= => true, :save => true))
        put :update, :id => "1"
        response.should redirect_to(tiers_url)
      end
    end
    
    describe "with invalid params" do
      it "updates the requested tier" do
        Tier.should_receive(:find).with("37").and_return(mock_tier(:save => false))
        mock_tier.should_receive(:attributes=).with({'these' => 'params'})
        put :update, :id => "37", :tier => {:these => 'params'}
      end

      it "assigns the tier as @tier" do
        Tier.stub!(:find).and_return(mock_tier(:attributes= => false, :save => false))
        put :update, :id => "1"
        assigns[:tier].should equal(mock_tier)
      end

      it "re-renders the 'edit' template" do
        Tier.stub!(:find).and_return(mock_tier(:attributes= => false, :save => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end
    
  end

  describe "DELETE destroy" do

    describe 'without delete_confirmation or used_at_all?' do
      
      it "destroys the requested tier" do
        Tier.should_receive(:find).with("37").and_return(mock_tier(:used_at_all? => false))
        mock_tier.should_receive(:destroy)
        delete :destroy, :id => "37"
      end
    
      it "redirects to the tiers list" do
        Tier.stub!(:find).and_return(mock_tier(:destroy => true, :used_at_all? =>false))
        delete :destroy, :id => "1"
        response.should redirect_to(tiers_url)
      end
    end

    describe 'with delete_confirmation' do
 
      it "destroys the requested tier" do
        Tier.should_receive(:find).with("37").and_return(mock_tier(:used_at_all? => true, :delete_successor => 'e'))
        mock_tier.should_receive(:destroy)
        delete :destroy, :id => "37", :delete_confirmation=>true
      end
    
      it "redirects to the tiers list" do
        Tier.stub!(:find).and_return(mock_tier(:destroy => true, :used_at_all? =>true, :delete_successor=>'e'))
        delete :destroy, :id => "1", :delete_confirmation=>true
        flash[:notice].should =~ /Records have been moved/
        response.should redirect_to(tiers_url)
      end

    end

    describe 'with used_at_all?' do
  
      it "does not destroys the requested tier" do
        Tier.should_receive(:find).with("37").and_return(mock_tier(:used_at_all? => true, :delete_successor => 'e'))
        mock_tier.should_not_receive(:destroy)
        delete :destroy, :id => "37"
      end
    
      it "redirects to the tiers list" do
        Tier.stub!(:find).and_return(mock_tier(:destroy => true, :used_at_all? =>true, :delete_successor=>'e'))
        delete :destroy, :id => "1"
        flash[:notice].should =~ /Tier in use/
        response.should render_template(:destroy)
      end


    end
  end

  

end
