require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PrincipalOverridesController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"

  before do
    @override=mock_principal_override
    @user=mock_user(:grouped_principal_overrides=>[@override],
                  :principal_override_requests=>PrincipalOverride)
    controller.stub!(:current_user => @user)
  end

  
  describe "responding to GET index" do

    it "should expose all principal_overrides as @principal_overrides" do
      @user.should_receive(:grouped_principal_overrides).and_return({:r=>[1,2,3]})
      get :index
      assigns[:principal_overrides].should == {:r=>[1,2,3]}
    end

  end

  describe "responding to GET new" do
  
    it "should expose a new principal_override as @principal_override" do
      pending
      PrincipalOverride.should_receive(:new).and_return(mock_principal_override)
      get :new
      assigns[:principal_override].should equal(mock_principal_override)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested principal_override as @principal_override" do
      pending
      overide=mock_principal_override
      PrincipalOverride.should_receive(:find).with("37").and_return(overide)
      get :edit, :id => "37"
      assigns[:principal_override].should equal(override)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created principal_override as @principal_override" do
        pending
        PrincipalOverride.should_receive(:new).with({'these' => 'params'}).and_return(mock_principal_override(:save => true))
        post :create, :principal_override => {:these => 'params'}
        assigns(:principal_override).should equal(mock_principal_override)
      end

      it "should redirect to the created principal_override" do
        pending
        PrincipalOverride.stub!(:new).and_return(mock_principal_override(:save => true))
        post :create, :principal_override => {}
        response.should redirect_to(principal_override_url(mock_principal_override))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved principal_override as @principal_override" do
        pending
        PrincipalOverride.stub!(:new).with({'these' => 'params'}).and_return(mock_principal_override(:save => false))
        post :create, :principal_override => {:these => 'params'}
        assigns(:principal_override).should equal(mock_principal_override)
      end

      it "should re-render the 'new' template" do
        pending
        PrincipalOverride.stub!(:new).and_return(mock_principal_override(:save => false))
        post :create, :principal_override => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested principal_override" do
        pending
        PrincipalOverride.should_receive(:find).with("37").and_return(mock_principal_override)
        mock_principal_override.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :principal_override => {:these => 'params'}
      end

      it "should expose the requested principal_override as @principal_override" do
        pending
        PrincipalOverride.stub!(:find).and_return(mock_principal_override(:update_attributes => true))
        put :update, :id => "1"
        assigns(:principal_override).should equal(mock_principal_override)
      end

      it "should redirect to the principal_override" do
        pending
        PrincipalOverride.stub!(:find).and_return(mock_principal_override(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(principal_override_url(mock_principal_override))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested principal_override" do
        pending
        PrincipalOverride.should_receive(:find).with("37").and_return(mock_principal_override)
        mock_principal_override.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :principal_override => {:these => 'params'}
      end

      it "should expose the principal_override as @principal_override" do
        pending

        PrincipalOverride.stub!(:find).and_return(mock_principal_override(:update_attributes => false))
        put :update, :id => "1"
        assigns(:principal_override).should equal(mock_principal_override)
      end

      it "should re-render the 'edit' template" do
        pending
        PrincipalOverride.stub!(:find).and_return(mock_principal_override(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested principal_override" do
      override=mock_principal_override
      PrincipalOverride.should_receive(:find).with("37").and_return(override)
      override.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
  end

end
