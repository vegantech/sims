require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Interventions::ProbesController do
  it_should_behave_like "an authorized controller"
  include_context "authorized"
  include_context "authenticated"


  def mock_probe(stubs={})
    @mock_probe ||= mock_model(Probe, stubs)
  end

  describe "responding to GET index" do

    it "should expose all probes as @probes" do
      student=mock_student
      @intervention=mock_intervention
      student.stub_association!(:interventions,:find=>@intervention)
      controller.stub!(:current_student).and_return(student)
      get :index, :intervention_id => @intervention.id, :probe_assignment_id => 2
      assigns(:intervention).should == @intervention

    end

  end

  describe "Has before filter" do
    before do
      student=mock_student
      @intervention=mock_intervention
      @intervention_probe_assignment = mock_model(InterventionProbeAssignment)
      @intervention.stub_association!(:intervention_probe_assignments,
                                      :find=>@intervention_probe_assignment)
      student.stub_association!(:interventions,:find=>@intervention)

      controller.stub!(:current_student).and_return(student)

    end

    describe "responding to GET new and set other instance vars" do

      it "should expose a new probe as @probe" do
        @intervention_probe_assignment.stub_association!(:probes,:build=>mock_probe)
        get :new, :intervention_id => @intervention.id, :probe_assignment_id => @intervention_probe_assignment.id
        assigns(:intervention).should == @intervention
        assigns(:intervention_probe_assignment).should == @intervention_probe_assignment
        assigns(:probe).should equal(mock_probe)
      end

    end

    describe "responding to GET edit" do

      it "should expose the requested probe as @probe" do
        @intervention_probe_assignment.stub_association!(:probes,:find=>mock_probe)
        get :edit, :id => "37",:intervention_id => @intervention.id, :probe_assignment_id => @intervention_probe_assignment.id
        assigns(:probe).should equal(mock_probe)
      end

    end

    describe "responding to POST create" do

      describe "with valid params" do

        it "should expose a newly created probe as @probe" do
          @intervention_probe_assignment.stub_association!(:probes,:new=>mock_probe(:save => true))
          post :create, :probe => {:these => 'params'},:intervention_id => @intervention.id, :probe_assignment_id => @intervention_probe_assignment.id
          assigns(:probe).should equal(mock_probe)
        end

        it "should redirect to the intervention" do
          @intervention_probe_assignment.stub_association!(:probes,:new=>mock_probe(:save => true))
          post :create, :probe => {},:intervention_id => @intervention.id, :probe_assignment_id => @intervention_probe_assignment.id
          response.should redirect_to(intervention_url(@intervention))
        end

      end

      describe "with invalid params" do

        it "should expose a newly created but unsaved probe as @probe" do
          @intervention_probe_assignment.stub_association!(:probes,:new=>mock_probe(:save => false))
          post :create, :probe => {:these => 'params'},:intervention_id => @intervention.id, :probe_assignment_id => @intervention_probe_assignment.id
          assigns(:probe).should equal(mock_probe)
        end

        it "should re-render the 'new' template" do
          @intervention_probe_assignment.stub_association!(:probes,:new=>mock_probe(:save => false))
          post :create, :probe => {},:intervention_id => @intervention.id, :probe_assignment_id => @intervention_probe_assignment.id
          response.should render_template('new')
        end

      end

    end

    describe "responding to PUT udpate" do

      describe "with valid params" do

        it "should update the requested probe" do
          @intervention_probe_assignment.stub_association!(:probes,:find=>mock_probe)
          mock_probe.should_receive(:update_attributes).with('these' => 'params')
          put :update, :id => "37", :probe => {:these => 'params'},:intervention_id => @intervention.id, :probe_assignment_id => @intervention_probe_assignment.id
        end

        it "should expose the requested probe as @probe" do
          @intervention_probe_assignment.stub_association!(:probes,:find=>mock_probe(:update_attributes=>true))

          put :update, :id => "1",:intervention_id => @intervention.id, :probe_assignment_id => @intervention_probe_assignment.id
          assigns(:probe).should equal(mock_probe)
        end

        it "should render update which closes window" do
          @intervention_probe_assignment.stub_association!(:probes,:find=>mock_probe(:update_attributes => true))
          put :update, :id => "1",:intervention_id => @intervention.id, :probe_assignment_id => @intervention_probe_assignment.id
          response.should render_template('update')
        end

      end

      describe "with invalid params" do

        it "should update the requested probe" do
          @intervention_probe_assignment.stub_association!(:probes,:find=>mock_probe)
          mock_probe.should_receive(:update_attributes).with('these' => 'params')
          put :update, :id => "37", :probe => {:these => 'params'},:intervention_id => @intervention.id, :probe_assignment_id => @intervention_probe_assignment.id
        end

        it "should expose the probe as @probe" do
          @intervention_probe_assignment.stub_association!(:probes,:find=>mock_probe(:update_attributes => false))
          put :update, :id => "1",:intervention_id => @intervention.id, :probe_assignment_id => @intervention_probe_assignment.id
          assigns(:probe).should equal(mock_probe),:intervention_id => @intervention.id, :probe_assignment_id => @intervention_probe_assignment.id
        end

        it "should re-render the 'edit' template" do
          @intervention_probe_assignment.stub_association!(:probes,:find=>mock_probe(:update_attributes => false))
          put :update, :id => "1",:intervention_id => @intervention.id, :probe_assignment_id => @intervention_probe_assignment.id
          response.should render_template('edit'),:intervention_id => @intervention.id, :probe_assignment_id => @intervention_probe_assignment.id
        end

      end

    end

    describe "responding to DELETE destroy" do

      it "should destroy the requested probe" do
        @intervention_probe_assignment.stub_association!(:probes,:find=>mock_probe)
        mock_probe.should_receive(:destroy)
        delete :destroy, :id => "37",:intervention_id => @intervention.id, :probe_assignment_id => @intervention_probe_assignment.id
      end

      it "should redirect to the probes list" do
        pending("remove if we never end up with html,  otherwise add a format to the delete")
        @intervention_probe_assignment.stub_association!(:probes,:find=>mock_probe(:destroy => true))
        delete :destroy, :id => "1",:intervention_id => @intervention.id, :probe_assignment_id => @intervention_probe_assignment.id
        response.should redirect_to(probes_url(@intervention,@intervention_probe_assignment))
      end

    end
  end

end
