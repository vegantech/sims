require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Interventions::ProbeAssignmentsController do

  def mock_intervention_probe_assignments(stubs={})
    @mock_intervention_probe_assignments ||= mock_model(InterventionProbeAssignments, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all intervention_probe_assignments as @intervention_probe_assignments" do
      pending
      InterventionProbeAssignments.should_receive(:find).with(:all).and_return([mock_intervention_probe_assignments])
      get :index
      assigns[:intervention_probe_assignments].should == [mock_intervention_probe_assignments]
    end

    describe "with mime type of xml" do
  
      it "should render all intervention_probe_assignments as xml" do
      pending
        request.env["HTTP_ACCEPT"] = "application/xml"
        InterventionProbeAssignments.should_receive(:find).with(:all).and_return(intervention_probe_assignments = mock("Array of InterventionProbeAssignments"))
        intervention_probe_assignments.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created intervention_probe_assignments as @intervention_probe_assignments" do
        pending
        InterventionProbeAssignments.should_receive(:new).with({'these' => 'params'}).and_return(mock_intervention_probe_assignments(:save => true))
        post :create, :intervention_probe_assignments => {:these => 'params'}
        assigns(:intervention_probe_assignments).should equal(mock_intervention_probe_assignments)
      end

      it "should redirect to the created intervention_probe_assignments" do
        pending
        InterventionProbeAssignments.stub!(:new).and_return(mock_intervention_probe_assignments(:save => true))
        post :create, :intervention_probe_assignments => {}
        response.should redirect_to(intervention_probe_assignment_url(mock_intervention_probe_assignments))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved intervention_probe_assignments as @intervention_probe_assignments" do
        pending
        InterventionProbeAssignments.stub!(:new).with({'these' => 'params'}).and_return(mock_intervention_probe_assignments(:save => false))
        post :create, :intervention_probe_assignments => {:these => 'params'}
        assigns(:intervention_probe_assignments).should equal(mock_intervention_probe_assignments)
      end

      it "should re-render the 'new' template" do
        pending
        InterventionProbeAssignments.stub!(:new).and_return(mock_intervention_probe_assignments(:save => false))
        post :create, :intervention_probe_assignments => {}
        response.should render_template('new')
      end
      
    end
    
  end

end
