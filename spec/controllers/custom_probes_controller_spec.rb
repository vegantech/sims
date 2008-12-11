require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CustomProbesController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"

  def mock_custom_probe(stubs={})
    @mock_custom_probe ||= mock_model(ProbeDefinition, stubs)
  end

  
  describe "responding to GET index" do

    it "should expose all custom_probes as @custom_probes" do
      ProbeDefinition.should_receive(:find).with(:all).and_return([mock_custom_probe])
      get :index
      assigns[:custom_probes].should == [mock_custom_probe]
    end

    describe "with mime type of xml" do
  
      it "should render all custom_probes as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        ProbeDefinition.should_receive(:find).with(:all).and_return(custom_probes = mock("Array of ProbeDefinitions"))
        custom_probes.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested custom_probe as @custom_probe" do
      ProbeDefinition.should_receive(:find).with("37").and_return(mock_custom_probe)
      get :show, :id => "37"
      assigns[:custom_probe].should equal(mock_custom_probe)
    end
    
    describe "with mime type of xml" do

      it "should render the requested custom_probe as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        ProbeDefinition.should_receive(:find).with("37").and_return(mock_custom_probe)
        mock_custom_probe.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new custom_probe as @custom_probe" do
      ProbeDefinition.should_receive(:new).and_return(mock_custom_probe)
      Intervention.should_receive(:find).with("1").and_return(mock_intervention)
      get :new, :intervention=>"1"
      assigns[:probe_definition].should equal(mock_custom_probe)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested custom_probe as @custom_probe" do
      ProbeDefinition.should_receive(:find).with("37").and_return(mock_custom_probe)
      get :edit, :id => "37"
      assigns[:custom_probe].should equal(mock_custom_probe)
    end

  end

  describe "responding to POST create" do
    before do 
      student=mock_student
      controller.should_receive(:current_student).and_return(student)
      student.should_receive(:interventions).and_return(Intervention)
      @intervention=mock_intervention
      Intervention.should_receive(:find).with("1").and_return(@intervention)
      
    end

    describe "with valid params" do
      
      it "should expose a newly created custom_probe as @custom_probe" do
        @intervention.should_receive(:build_custom_probe).with({'these' => 'params'}).and_return(mock_custom_probe(:save => true))
        post :create, :probe_definition => {:these => 'params'},:intervention=>"1"
        assigns(:probe_definition).should equal(mock_custom_probe)
      end

      it "should redirect to the created custom_probe" do
        @intervention.stub!(:build_custom_probe).and_return(mock_custom_probe(:save => true))
        post :create, :probe_definition => {},:intervention=>"1"
        response.should redirect_to(intervention_probe_assignments_url(@intervention))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved custom_probe as @custom_probe" do
        @intervention.stub!(:build_custom_probe).with({'these' => 'params'}).and_return(mock_custom_probe(:save => false))
        post :create, :probe_definition => {:these => 'params'}, :intervention => "1"
        assigns(:probe_definition).should equal(mock_custom_probe)
      end

      it "should re-render the 'new' template" do
        @intervention.stub!(:build_custom_probe).and_return(mock_custom_probe(:save => false))
        post :create, :probe_definition => {}, :intervention => "1"
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested custom_probe" do
        ProbeDefinition.should_receive(:find).with("37").and_return(mock_custom_probe)
        mock_custom_probe.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :custom_probe => {:these => 'params'}
      end

      it "should expose the requested custom_probe as @custom_probe" do
        ProbeDefinition.stub!(:find).and_return(mock_custom_probe(:update_attributes => true))
        put :update, :id => "1"
        assigns(:custom_probe).should equal(mock_custom_probe)
      end

      it "should redirect to the custom_probe" do
        ProbeDefinition.stub!(:find).and_return(mock_custom_probe(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(custom_probe_url(mock_custom_probe))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested custom_probe" do
        ProbeDefinition.should_receive(:find).with("37").and_return(mock_custom_probe)
        mock_custom_probe.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :custom_probe => {:these => 'params'}
      end

      it "should expose the custom_probe as @custom_probe" do
        ProbeDefinition.stub!(:find).and_return(mock_custom_probe(:update_attributes => false))
        put :update, :id => "1"
        assigns(:custom_probe).should equal(mock_custom_probe)
      end

      it "should re-render the 'edit' template" do
        ProbeDefinition.stub!(:find).and_return(mock_custom_probe(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested custom_probe" do
      ProbeDefinition.should_receive(:find).with("37").and_return(mock_custom_probe)
      mock_custom_probe.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the custom_probes list" do
      ProbeDefinition.stub!(:find).and_return(mock_custom_probe(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(custom_probes_url)
    end

  end

end
