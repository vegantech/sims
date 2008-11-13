require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe IgnoreFlagsController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"

  def mock_ignore_flag(stubs={})
    @mock_ignore_flag ||= mock_model(IgnoreFlag, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all ignore_flags as @ignore_flags" do
      IgnoreFlag.should_receive(:find).with(:all).and_return([mock_ignore_flag])
      get :index
      assigns[:ignore_flags].should == [mock_ignore_flag]
    end

    describe "with mime type of xml" do
  
      it "should render all ignore_flags as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        IgnoreFlag.should_receive(:find).with(:all).and_return(ignore_flags = mock("Array of IgnoreFlags"))
        ignore_flags.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested ignore_flag as @ignore_flag" do
      IgnoreFlag.should_receive(:find).with("37").and_return(mock_ignore_flag)
      get :show, :id => "37"
      assigns[:ignore_flag].should equal(mock_ignore_flag)
    end
    
    describe "with mime type of xml" do

      it "should render the requested ignore_flag as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        IgnoreFlag.should_receive(:find).with("37").and_return(mock_ignore_flag)
        mock_ignore_flag.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new ignore_flag as @ignore_flag" do
      IgnoreFlag.should_receive(:new).and_return(mock_ignore_flag)
      get :new
      assigns[:ignore_flag].should equal(mock_ignore_flag)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested ignore_flag as @ignore_flag" do
      IgnoreFlag.should_receive(:find).with("37").and_return(mock_ignore_flag)
      get :edit, :id => "37"
      assigns[:ignore_flag].should equal(mock_ignore_flag)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created ignore_flag as @ignore_flag" do
        IgnoreFlag.should_receive(:new).with({'these' => 'params'}).and_return(mock_ignore_flag(:save => true))
        post :create, :ignore_flag => {:these => 'params'}
        assigns(:ignore_flag).should equal(mock_ignore_flag)
      end

      it "should redirect to the created ignore_flag" do
        IgnoreFlag.stub!(:new).and_return(mock_ignore_flag(:save => true))
        post :create, :ignore_flag => {}
        response.should redirect_to(ignore_flag_url(mock_ignore_flag))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved ignore_flag as @ignore_flag" do
        IgnoreFlag.stub!(:new).with({'these' => 'params'}).and_return(mock_ignore_flag(:save => false))
        post :create, :ignore_flag => {:these => 'params'}
        assigns(:ignore_flag).should equal(mock_ignore_flag)
      end

      it "should re-render the 'new' template" do
        IgnoreFlag.stub!(:new).and_return(mock_ignore_flag(:save => false))
        post :create, :ignore_flag => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested ignore_flag" do
        IgnoreFlag.should_receive(:find).with("37").and_return(mock_ignore_flag)
        mock_ignore_flag.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :ignore_flag => {:these => 'params'}
      end

      it "should expose the requested ignore_flag as @ignore_flag" do
        IgnoreFlag.stub!(:find).and_return(mock_ignore_flag(:update_attributes => true))
        put :update, :id => "1"
        assigns(:ignore_flag).should equal(mock_ignore_flag)
      end

      it "should redirect to the ignore_flag" do
        IgnoreFlag.stub!(:find).and_return(mock_ignore_flag(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(ignore_flag_url(mock_ignore_flag))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested ignore_flag" do
        IgnoreFlag.should_receive(:find).with("37").and_return(mock_ignore_flag)
        mock_ignore_flag.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :ignore_flag => {:these => 'params'}
      end

      it "should expose the ignore_flag as @ignore_flag" do
        IgnoreFlag.stub!(:find).and_return(mock_ignore_flag(:update_attributes => false))
        put :update, :id => "1"
        assigns(:ignore_flag).should equal(mock_ignore_flag)
      end

      it "should re-render the 'edit' template" do
        IgnoreFlag.stub!(:find).and_return(mock_ignore_flag(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested ignore_flag" do
      IgnoreFlag.should_receive(:find).with("37").and_return(mock_ignore_flag)
      mock_ignore_flag.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the ignore_flags list" do
      IgnoreFlag.stub!(:find).and_return(mock_ignore_flag(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(ignore_flags_url)
    end

  end

end
