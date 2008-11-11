require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PrincipalOverridesController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"

  def mock_principal_override(stubs={})
    @mock_principal_override ||= mock_model(PrincipalOverride, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all principal_overrides as @principal_overrides" do
      PrincipalOverride.should_receive(:find).with(:all).and_return([mock_principal_override])
      get :index
      assigns[:principal_overrides].should == [mock_principal_override]
    end

    describe "with mime type of xml" do
  
      it "should render all principal_overrides as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        PrincipalOverride.should_receive(:find).with(:all).and_return(principal_overrides = mock("Array of PrincipalOverrides"))
        principal_overrides.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested principal_override as @principal_override" do
      PrincipalOverride.should_receive(:find).with("37").and_return(mock_principal_override)
      get :show, :id => "37"
      assigns[:principal_override].should equal(mock_principal_override)
    end
    
    describe "with mime type of xml" do

      it "should render the requested principal_override as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        PrincipalOverride.should_receive(:find).with("37").and_return(mock_principal_override)
        mock_principal_override.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

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
      PrincipalOverride.should_receive(:find).with("37").and_return(mock_principal_override)
      get :edit, :id => "37"
      assigns[:principal_override].should equal(mock_principal_override)
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
        PrincipalOverride.should_receive(:find).with("37").and_return(mock_principal_override)
        mock_principal_override.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :principal_override => {:these => 'params'}
      end

      it "should expose the requested principal_override as @principal_override" do
        PrincipalOverride.stub!(:find).and_return(mock_principal_override(:update_attributes => true))
        put :update, :id => "1"
        assigns(:principal_override).should equal(mock_principal_override)
      end

      it "should redirect to the principal_override" do
        PrincipalOverride.stub!(:find).and_return(mock_principal_override(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(principal_override_url(mock_principal_override))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested principal_override" do
        PrincipalOverride.should_receive(:find).with("37").and_return(mock_principal_override)
        mock_principal_override.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :principal_override => {:these => 'params'}
      end

      it "should expose the principal_override as @principal_override" do
        PrincipalOverride.stub!(:find).and_return(mock_principal_override(:update_attributes => false))
        put :update, :id => "1"
        assigns(:principal_override).should equal(mock_principal_override)
      end

      it "should re-render the 'edit' template" do
        PrincipalOverride.stub!(:find).and_return(mock_principal_override(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested principal_override" do
      PrincipalOverride.should_receive(:find).with("37").and_return(mock_principal_override)
      mock_principal_override.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the principal_overrides list" do
      PrincipalOverride.stub!(:find).and_return(mock_principal_override(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(principal_overrides_url)
    end

  end

end
