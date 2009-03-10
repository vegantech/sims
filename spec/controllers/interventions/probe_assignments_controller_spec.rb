require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Interventions::ProbeAssignmentsController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"

  def mock_intervention_probe_assignments(stubs={})
    @mock_intervention_probe_assignments ||= mock_model(InterventionProbeAssignments, stubs)
  end

  def params
    {:intervention_id=>1}
  end
  
  before do
    @student=mock_student
    @intervention=mock_intervention
    @student.stub_association!(:interventions,:find=>@intervention)
    controller.stub!(:current_student=>@student)
  end

  it 'should load_intervention' do
   controller.should_receive(:params).and_return(params)
   controller.send(:load_intervention).should ==(@intervention)
  end

  describe "responding to GET index" do

    it "should expose all intervention_probe_assignment as @intervention_probe_assignments" do
      @intervention.should_receive(:intervention_probe_assignments).and_return([])
      ipa=mock_intervention_probe_assignment
      @intervention.should_receive(:intervention_probe_assignment).and_return(ipa)
      
      get :index, :intervention_id => 1
      assigns[:intervention_probe_assignments].should == [ipa]
      assigns[:intervention].should == @intervention
      response.should be_success
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
