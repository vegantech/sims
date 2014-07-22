require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Interventions::ParticipantsController do
  it_should_behave_like "an authorized controller"
  include_context "authorized"
  include_context "authenticated"

  def mock_intervention_participant(stubs={})
    @mock_intervention_participant ||= mock_model(InterventionParticipant, stubs)
  end

  before :each do
    student=mock_student
    @intervention=mock_intervention
    student.stub_association!(:interventions,find: @intervention)
    @intervention.stub_association!(:intervention_participants, build: mock_intervention_participant, find: mock_intervention_participant,
                                                                find_by_user_id: mock_intervention_participant)
    controller.stub!(:current_student).and_return(student)
    controller.stub!(:current_school).and_return(mock_school(assigned_users: [1,2,3]))
  end

  describe "responding to GET new" do

    it "should expose a new intervention_participant as @intervention_participant" do
      get :new, intervention_id: @intervention.id
      assigns(:intervention_participant).should equal(mock_intervention_participant)
      assigns(:users).should ==([nil,1,2,3])
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      before :each do
        @mock_intervention_participant.should_receive(:save).and_return(true)
        @mock_intervention_participant.stub!(role_title: "ROLE")

      end

      it "should expose a newly created intervention_participant as @intervention_participant" do
        post :create, intervention_participant: {these: 'params'}, intervention_id: @intervention.id
        assigns(:intervention_participant).should equal(mock_intervention_participant)
      end

      it "should redirect to the created intervention_participant" do
        post :create, intervention_participant: {}, intervention_id: @intervention.id
        response.should redirect_to(intervention_url(@intervention))
      end

    end

    describe "with invalid params" do

      before :each do
        @mock_intervention_participant.should_receive(:save).and_return(false)
      end
      it "should expose a newly created but unsaved intervention_participant as @intervention_participant" do
        post :create, intervention_participant: {these: 'params'}, intervention_id: @intervention.id
        assigns(:intervention_participant).should equal(mock_intervention_participant)
      end

      it "should re-render the 'new' template" do
        post :create, intervention_participant: {}, intervention_id: @intervention.id
        response.should render_template('new')
      end

    end

  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested intervention_participant" do
        pending
        InterventionParticipant.should_receive(:find).with("37").and_return(mock_intervention_participant)
        mock_intervention_participant.should_receive(:update_attributes).with('these' => 'params')
        put :update, id: "37", intervention_participant: {these: 'params'}, intervention_id: @intervention.id
      end

      it "should expose the requested intervention_participant as @intervention_participant" do
        pending
        InterventionParticipant.stub!(:find).and_return(mock_intervention_participant(update_attributes: true))
        put :update, id: "1", intervention_id: @intervention.id
        assigns(:intervention_participant).should equal(mock_intervention_participant)
      end

      it "should redirect to the intervention_participant" do
        pending
        InterventionParticipant.stub!(:find).and_return(mock_intervention_participant(update_attributes: true))
        put :update, id: "1", intervention_id: @intervention.id
        response.should redirect_to(intervention_url(@intervention))
      end

    end

    describe "with invalid params" do

      it "should update the requested intervention_participant" do
        pending
        InterventionParticipant.should_receive(:find).with("37").and_return(mock_intervention_participant)
        mock_intervention_participant.should_receive(:update_attributes).with('these' => 'params')
        put :update, id: "37", intervention_participant: {these: 'params'}, intervention_id: @intervention.id
      end

      it "should expose the intervention_participant as @intervention_participant" do
        pending
        InterventionParticipant.stub!(:find).and_return(mock_intervention_participant(update_attributes: false))
        put :update, id: "1", intervention_id: @intervention.id
        assigns(:intervention_participant).should equal(mock_intervention_participant)
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested intervention_participant" do
      mock_intervention_participant.should_receive(:destroy)
      delete :destroy, id: "37", intervention_id: @intervention.id
    end

    it "should redirect to the intervention_participants list" do
      mock_intervention_participant.should_receive(:destroy)
      delete :destroy, id: "1", format: "html", intervention_id: @intervention.id
      response.should redirect_to(intervention_url(@intervention))
    end

  end

end
