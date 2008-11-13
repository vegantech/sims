require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Interventions::ParticipantsController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"

  def mock_intervention_participant(stubs={})
    @mock_intervention_participant ||= mock_model(InterventionParticipant, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all intervention_participants as @intervention_participants" do ;pending
      InterventionParticipant.should_receive(:find).with(:all).and_return([mock_intervention_participant])
      get :index
      assigns[:intervention_participants].should == [mock_intervention_participant]
    end

    describe "with mime type of xml" do
  
      it "should render all intervention_participants as xml" do ;pending
        request.env["HTTP_ACCEPT"] = "application/xml"
        InterventionParticipant.should_receive(:find).with(:all).and_return(intervention_participants = mock("Array of InterventionParticipants"))
        intervention_participants.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested intervention_participant as @intervention_participant" do ;pending
      InterventionParticipant.should_receive(:find).with("37").and_return(mock_intervention_participant)
      get :show, :id => "37"
      assigns[:intervention_participant].should equal(mock_intervention_participant)
    end
    
    describe "with mime type of xml" do

      it "should render the requested intervention_participant as xml" do ;pending
        request.env["HTTP_ACCEPT"] = "application/xml"
        InterventionParticipant.should_receive(:find).with("37").and_return(mock_intervention_participant)
        mock_intervention_participant.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new intervention_participant as @intervention_participant" do ;pending
      InterventionParticipant.should_receive(:new).and_return(mock_intervention_participant)
      get :new
      assigns[:intervention_participant].should equal(mock_intervention_participant)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested intervention_participant as @intervention_participant" do ;pending
      InterventionParticipant.should_receive(:find).with("37").and_return(mock_intervention_participant)
      get :edit, :id => "37"
      assigns[:intervention_participant].should equal(mock_intervention_participant)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created intervention_participant as @intervention_participant" do ;pending
        InterventionParticipant.should_receive(:new).with({'these' => 'params'}).and_return(mock_intervention_participant(:save => true))
        post :create, :intervention_participant => {:these => 'params'}
        assigns(:intervention_participant).should equal(mock_intervention_participant)
      end

      it "should redirect to the created intervention_participant" do ;pending
        InterventionParticipant.stub!(:new).and_return(mock_intervention_participant(:save => true))
        post :create, :intervention_participant => {}
        response.should redirect_to(intervention_participant_url(mock_intervention_participant))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved intervention_participant as @intervention_participant" do ;pending
        InterventionParticipant.stub!(:new).with({'these' => 'params'}).and_return(mock_intervention_participant(:save => false))
        post :create, :intervention_participant => {:these => 'params'}
        assigns(:intervention_participant).should equal(mock_intervention_participant)
      end

      it "should re-render the 'new' template" do ;pending
        InterventionParticipant.stub!(:new).and_return(mock_intervention_participant(:save => false))
        post :create, :intervention_participant => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested intervention_participant" do ;pending
        InterventionParticipant.should_receive(:find).with("37").and_return(mock_intervention_participant)
        mock_intervention_participant.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :intervention_participant => {:these => 'params'}
      end

      it "should expose the requested intervention_participant as @intervention_participant" do ;pending
        InterventionParticipant.stub!(:find).and_return(mock_intervention_participant(:update_attributes => true))
        put :update, :id => "1"
        assigns(:intervention_participant).should equal(mock_intervention_participant)
      end

      it "should redirect to the intervention_participant" do ;pending
        InterventionParticipant.stub!(:find).and_return(mock_intervention_participant(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(intervention_participant_url(mock_intervention_participant))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested intervention_participant" do ;pending
        InterventionParticipant.should_receive(:find).with("37").and_return(mock_intervention_participant)
        mock_intervention_participant.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :intervention_participant => {:these => 'params'}
      end

      it "should expose the intervention_participant as @intervention_participant" do ;pending
        InterventionParticipant.stub!(:find).and_return(mock_intervention_participant(:update_attributes => false))
        put :update, :id => "1"
        assigns(:intervention_participant).should equal(mock_intervention_participant)
      end

      it "should re-render the 'edit' template" do ;pending
        InterventionParticipant.stub!(:find).and_return(mock_intervention_participant(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested intervention_participant" do ;pending
      InterventionParticipant.should_receive(:find).with("37").and_return(mock_intervention_participant)
      mock_intervention_participant.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the intervention_participants list" do ;pending
      InterventionParticipant.stub!(:find).and_return(mock_intervention_participant(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(intervention_participants_url)
    end

  end

end
