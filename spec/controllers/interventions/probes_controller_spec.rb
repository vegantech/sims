require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Interventions::ProbesController do
  it_should_behave_like "an authenticated controller"
  
  before do
    student=mock_student
    @intervention=mock_intervention
    @intervention_probe_assignment = mock_model(InterventionProbeAssignment)
    @intervention.stub_association!(:intervention_probe_assignments,
                                   :find=>@intervention_probe_assignment)
    student.stub_association!(:interventions,:find=>@intervention)

    controller.should_receive(:current_student).and_return(student)

  end

  def mock_probe(stubs={})
    @mock_probe ||= mock_model(Probe, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all probes as @probes and set other instance vars" do
      @intervention_probe_assignment.should_receive(:probes).and_return([mock_probe])
      get :index
      assigns(:intervention).should == @intervention
      assigns(:intervention_probe_assignment).should == @intervention_probe_assignment

     assigns[:probes].should == [mock_probe]
    end

  end

  describe "responding to GET show" do

    it "should expose the requested probe as @probe" do
      @intervention_probe_assignment.stub_association!(:probes,:find=>mock_probe)
      get :show, :id => "37"
      assigns[:probe].should equal(mock_probe)
    end
   
  end

  describe "responding to GET new" do
  
    it "should expose a new probe as @probe" do
      @intervention_probe_assignment.stub_association!(:probes,:new=>mock_probe)
      get :new
      assigns[:probe].should equal(mock_probe)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested probe as @probe" do
      @intervention_probe_assignment.stub_association!(:probes,:find=>mock_probe)
      get :edit, :id => "37"
      assigns[:probe].should equal(mock_probe)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created probe as @probe" do
        @intervention_probe_assignment.stub_association!(:probes,:new=>mock_probe(:save => true))
        post :create, :probe => {:these => 'params'}
        assigns(:probe).should equal(mock_probe)
      end

      it "should redirect to the created probe" do
        @intervention_probe_assignment.stub_association!(:probes,:new=>mock_probe(:save => true))
        post :create, :probe => {}
        response.should redirect_to(probe_url(@intervention,@intervention_probe_assignment,mock_probe))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved probe as @probe" do
        @intervention_probe_assignment.stub_association!(:probes,:new=>mock_probe(:save => false))
        post :create, :probe => {:these => 'params'}
        assigns(:probe).should equal(mock_probe)
      end

      it "should re-render the 'new' template" do
        @intervention_probe_assignment.stub_association!(:probes,:new=>mock_probe(:save => false))
        post :create, :probe => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested probe" do
        @intervention_probe_assignment.stub_association!(:probes,:find=>mock_probe)
        mock_probe.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :probe => {:these => 'params'}
      end

      it "should expose the requested probe as @probe" do
        @intervention_probe_assignment.stub_association!(:probes,:find=>mock_probe(:update_attributes=>true))
        
        put :update, :id => "1"
        assigns(:probe).should equal(mock_probe)
      end

      it "should redirect to the probe" do
        @intervention_probe_assignment.stub_association!(:probes,:find=>mock_probe(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(probe_url(@intervention,@intervention_probe_assignment,mock_probe))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested probe" do
        @intervention_probe_assignment.stub_association!(:probes,:find=>mock_probe)
        mock_probe.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :probe => {:these => 'params'}
      end

      it "should expose the probe as @probe" do
        @intervention_probe_assignment.stub_association!(:probes,:find=>mock_probe(:update_attributes => false))
        put :update, :id => "1"
        assigns(:probe).should equal(mock_probe)
      end

      it "should re-render the 'edit' template" do
        @intervention_probe_assignment.stub_association!(:probes,:find=>mock_probe(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested probe" do
      @intervention_probe_assignment.stub_association!(:probes,:find=>mock_probe)
      mock_probe.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the probes list" do
      @intervention_probe_assignment.stub_association!(:probes,:find=>mock_probe(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(probes_url(@intervention,@intervention_probe_assignment))
    end

  end

end
