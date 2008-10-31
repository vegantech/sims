require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Interventions::ProbesController do
  it_should_behave_like "an authenticated controller"

  def mock_probe(stubs={})
    @mock_probe ||= mock_model(Probe, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all probes as @probes" do
      Probe.should_receive(:find).with(:all).and_return([mock_probe])
      get :index
      assigns[:probes].should == [mock_probe]
    end

    describe "with mime type of xml" do
  
      it "should render all probes as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Probe.should_receive(:find).with(:all).and_return(probes = mock("Array of Probes"))
        probes.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested probe as @probe" do
      Probe.should_receive(:find).with("37").and_return(mock_probe)
      get :show, :id => "37"
      assigns[:probe].should equal(mock_probe)
    end
    
    describe "with mime type of xml" do

      it "should render the requested probe as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Probe.should_receive(:find).with("37").and_return(mock_probe)
        mock_probe.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new probe as @probe" do
      Probe.should_receive(:new).and_return(mock_probe)
      get :new
      assigns[:probe].should equal(mock_probe)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested probe as @probe" do
      Probe.should_receive(:find).with("37").and_return(mock_probe)
      get :edit, :id => "37"
      assigns[:probe].should equal(mock_probe)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created probe as @probe" do
        pending
        Probe.should_receive(:new).with({'these' => 'params'}).and_return(mock_probe(:save => true))
        post :create, :probe => {:these => 'params'}
        assigns(:probe).should equal(mock_probe)
      end

      it "should redirect to the created probe" do
        pending
        Probe.stub!(:new).and_return(mock_probe(:save => true))
        post :create, :probe => {}
        response.should redirect_to(probe_url(mock_probe))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved probe as @probe" do
        Probe.stub!(:new).with({'these' => 'params'}).and_return(mock_probe(:save => false))
        post :create, :probe => {:these => 'params'}
        assigns(:probe).should equal(mock_probe)
      end

      it "should re-render the 'new' template" do
        Probe.stub!(:new).and_return(mock_probe(:save => false))
        post :create, :probe => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested probe" do
        Probe.should_receive(:find).with("37").and_return(mock_probe)
        mock_probe.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :probe => {:these => 'params'}
      end

      it "should expose the requested probe as @probe" do
        pending
        Probe.stub!(:find).and_return(mock_probe(:update_attributes => true))
        put :update, :id => "1"
        assigns(:probe).should equal(mock_probe)
      end

      it "should redirect to the probe" do
        pending
        Probe.stub!(:find).and_return(mock_probe(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(probe_url(mock_probe))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested probe" do
        Probe.should_receive(:find).with("37").and_return(mock_probe)
        mock_probe.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :probe => {:these => 'params'}
      end

      it "should expose the probe as @probe" do
        Probe.stub!(:find).and_return(mock_probe(:update_attributes => false))
        put :update, :id => "1"
        assigns(:probe).should equal(mock_probe)
      end

      it "should re-render the 'edit' template" do
        Probe.stub!(:find).and_return(mock_probe(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested probe" do
      pending
      Probe.should_receive(:find).with("37").and_return(mock_probe)
      mock_probe.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the probes list" do
      pending
      Probe.stub!(:find).and_return(mock_probe(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(probes_url)
    end

  end

end
