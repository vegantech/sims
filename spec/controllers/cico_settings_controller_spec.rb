require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CICOSettingsController do

  def mock_cico_setting(stubs={})
    @mock_cico_setting ||= mock_model(CICOSetting, stubs)
  end
  
  describe "GET index" do
    it "assigns all cico_settings as @cico_settings" do
      CICOSetting.should_receive(:find).with(:all).and_return([mock_cico_setting])
      get :index
      assigns[:cico_settings].should == [mock_cico_setting]
    end
  end

  describe "GET show" do
    it "assigns the requested cico_setting as @cico_setting" do
      CICOSetting.should_receive(:find).with("37").and_return(mock_cico_setting)
      get :show, :id => "37"
      assigns[:cico_setting].should equal(mock_cico_setting)
    end
  end

  describe "GET new" do
    it "assigns a new cico_setting as @cico_setting" do
      CICOSetting.should_receive(:new).and_return(mock_cico_setting)
      get :new
      assigns[:cico_setting].should equal(mock_cico_setting)
    end
  end

  describe "GET edit" do
    it "assigns the requested cico_setting as @cico_setting" do
      CICOSetting.should_receive(:find).with("37").and_return(mock_cico_setting)
      get :edit, :id => "37"
      assigns[:cico_setting].should equal(mock_cico_setting)
    end
  end

  describe "POST create" do
    
    describe "with valid params" do
      it "assigns a newly created cico_setting as @cico_setting" do
        CICOSetting.should_receive(:new).with({'these' => 'params'}).and_return(mock_cico_setting(:save => true))
        post :create, :cico_setting => {:these => 'params'}
        assigns[:cico_setting].should equal(mock_cico_setting)
      end

      it "redirects to the created cico_setting" do
        CICOSetting.stub!(:new).and_return(mock_cico_setting(:save => true))
        post :create, :cico_setting => {}
        response.should redirect_to(cico_setting_url(mock_cico_setting))
      end
    end
    
    describe "with invalid params" do
      it "assigns a newly created but unsaved cico_setting as @cico_setting" do
        CICOSetting.stub!(:new).with({'these' => 'params'}).and_return(mock_cico_setting(:save => false))
        post :create, :cico_setting => {:these => 'params'}
        assigns[:cico_setting].should equal(mock_cico_setting)
      end

      it "re-renders the 'new' template" do
        CICOSetting.stub!(:new).and_return(mock_cico_setting(:save => false))
        post :create, :cico_setting => {}
        response.should render_template('new')
      end
    end
    
  end

  describe "PUT udpate" do
    
    describe "with valid params" do
      it "updates the requested cico_setting" do
        CICOSetting.should_receive(:find).with("37").and_return(mock_cico_setting)
        mock_cico_setting.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :cico_setting => {:these => 'params'}
      end

      it "assigns the requested cico_setting as @cico_setting" do
        CICOSetting.stub!(:find).and_return(mock_cico_setting(:update_attributes => true))
        put :update, :id => "1"
        assigns[:cico_setting].should equal(mock_cico_setting)
      end

      it "redirects to the cico_setting" do
        CICOSetting.stub!(:find).and_return(mock_cico_setting(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(cico_setting_url(mock_cico_setting))
      end
    end
    
    describe "with invalid params" do
      it "updates the requested cico_setting" do
        CICOSetting.should_receive(:find).with("37").and_return(mock_cico_setting)
        mock_cico_setting.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :cico_setting => {:these => 'params'}
      end

      it "assigns the cico_setting as @cico_setting" do
        CICOSetting.stub!(:find).and_return(mock_cico_setting(:update_attributes => false))
        put :update, :id => "1"
        assigns[:cico_setting].should equal(mock_cico_setting)
      end

      it "re-renders the 'edit' template" do
        CICOSetting.stub!(:find).and_return(mock_cico_setting(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end
    
  end

  describe "DELETE destroy" do
    it "destroys the requested cico_setting" do
      CICOSetting.should_receive(:find).with("37").and_return(mock_cico_setting)
      mock_cico_setting.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "redirects to the cico_settings list" do
      CICOSetting.stub!(:find).and_return(mock_cico_setting(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(cico_settings_url)
    end
  end

end
