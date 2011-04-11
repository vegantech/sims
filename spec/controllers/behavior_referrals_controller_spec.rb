require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BehaviorReferralsController do

  def mock_behavior_referral(stubs={})
    @mock_behavior_referral ||= mock_model(BehaviorReferral, stubs)
  end
  
  describe "GET index" do
    it "assigns all behavior_referrals as @behavior_referrals" do
      BehaviorReferral.should_receive(:find).with(:all).and_return([mock_behavior_referral])
      get :index
      assigns[:behavior_referrals].should == [mock_behavior_referral]
    end
  end

  describe "GET show" do
    it "assigns the requested behavior_referral as @behavior_referral" do
      BehaviorReferral.should_receive(:find).with("37").and_return(mock_behavior_referral)
      get :show, :id => "37"
      assigns[:behavior_referral].should equal(mock_behavior_referral)
    end
  end

  describe "GET new" do
    it "assigns a new behavior_referral as @behavior_referral" do
      BehaviorReferral.should_receive(:new).and_return(mock_behavior_referral)
      get :new
      assigns[:behavior_referral].should equal(mock_behavior_referral)
    end
  end

  describe "GET edit" do
    it "assigns the requested behavior_referral as @behavior_referral" do
      BehaviorReferral.should_receive(:find).with("37").and_return(mock_behavior_referral)
      get :edit, :id => "37"
      assigns[:behavior_referral].should equal(mock_behavior_referral)
    end
  end

  describe "POST create" do
    
    describe "with valid params" do
      it "assigns a newly created behavior_referral as @behavior_referral" do
        BehaviorReferral.should_receive(:new).with({'these' => 'params'}).and_return(mock_behavior_referral(:save => true))
        post :create, :behavior_referral => {:these => 'params'}
        assigns[:behavior_referral].should equal(mock_behavior_referral)
      end

      it "redirects to the created behavior_referral" do
        BehaviorReferral.stub!(:new).and_return(mock_behavior_referral(:save => true))
        post :create, :behavior_referral => {}
        response.should redirect_to(behavior_referral_url(mock_behavior_referral))
      end
    end
    
    describe "with invalid params" do
      it "assigns a newly created but unsaved behavior_referral as @behavior_referral" do
        BehaviorReferral.stub!(:new).with({'these' => 'params'}).and_return(mock_behavior_referral(:save => false))
        post :create, :behavior_referral => {:these => 'params'}
        assigns[:behavior_referral].should equal(mock_behavior_referral)
      end

      it "re-renders the 'new' template" do
        BehaviorReferral.stub!(:new).and_return(mock_behavior_referral(:save => false))
        post :create, :behavior_referral => {}
        response.should render_template('new')
      end
    end
    
  end

  describe "PUT udpate" do
    
    describe "with valid params" do
      it "updates the requested behavior_referral" do
        BehaviorReferral.should_receive(:find).with("37").and_return(mock_behavior_referral)
        mock_behavior_referral.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :behavior_referral => {:these => 'params'}
      end

      it "assigns the requested behavior_referral as @behavior_referral" do
        BehaviorReferral.stub!(:find).and_return(mock_behavior_referral(:update_attributes => true))
        put :update, :id => "1"
        assigns[:behavior_referral].should equal(mock_behavior_referral)
      end

      it "redirects to the behavior_referral" do
        BehaviorReferral.stub!(:find).and_return(mock_behavior_referral(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(behavior_referral_url(mock_behavior_referral))
      end
    end
    
    describe "with invalid params" do
      it "updates the requested behavior_referral" do
        BehaviorReferral.should_receive(:find).with("37").and_return(mock_behavior_referral)
        mock_behavior_referral.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :behavior_referral => {:these => 'params'}
      end

      it "assigns the behavior_referral as @behavior_referral" do
        BehaviorReferral.stub!(:find).and_return(mock_behavior_referral(:update_attributes => false))
        put :update, :id => "1"
        assigns[:behavior_referral].should equal(mock_behavior_referral)
      end

      it "re-renders the 'edit' template" do
        BehaviorReferral.stub!(:find).and_return(mock_behavior_referral(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end
    
  end

  describe "DELETE destroy" do
    it "destroys the requested behavior_referral" do
      BehaviorReferral.should_receive(:find).with("37").and_return(mock_behavior_referral)
      mock_behavior_referral.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "redirects to the behavior_referrals list" do
      BehaviorReferral.stub!(:find).and_return(mock_behavior_referral(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(behavior_referrals_url)
    end
  end

end
