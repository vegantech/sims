require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TeamConsultationsController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"
      

  def mock_team_consultation(stubs={})
    @mock_team_consultation ||= mock_model(TeamConsultation, stubs)
  end
  
  describe "GET index" do
    it "assigns all team_consultations as @team_consultations" do
      TeamConsultation.should_receive(:find).with(:all).and_return([mock_team_consultation])
      get :index
      assigns[:team_consultations].should == [mock_team_consultation]
    end
  end

  describe "GET show" do
    it "assigns the requested team_consultation as @team_consultation" do
      TeamConsultation.should_receive(:find).with("37").and_return(mock_team_consultation)
      get :show, :id => "37"
      assigns[:team_consultation].should equal(mock_team_consultation)
    end
  end

  describe "GET new" do
    it "assigns a new team_consultation as @team_consultation" do
      TeamConsultation.should_receive(:new).and_return(mock_team_consultation)
      get :new
      assigns[:team_consultation].should equal(mock_team_consultation)
    end
  end

  describe "GET edit" do
    it "assigns the requested team_consultation as @team_consultation" do
      TeamConsultation.should_receive(:find).with("37").and_return(mock_team_consultation)
      get :edit, :id => "37"
      assigns[:team_consultation].should equal(mock_team_consultation)
    end
  end

  describe "POST create" do
    before do
      @mock_student = mock_student
      controller.stub!(:current_student_id => '2', :current_user_id => '3', :current_student => @mock_student)
    end
    
    describe "with valid params" do
      it "assigns a newly created team_consultation as @team_consultation" do
        TeamConsultation.should_receive(:new).with({'these' => 'params', 'student_id' => '2', 'requestor_id' => '3'}).and_return(mock_team_consultation(:save => true))
        post :create, :team_consultation => {:these => 'params'}
        assigns[:team_consultation].should equal(mock_team_consultation)
      end

      it "redirects back to the student profile" do
        TeamConsultation.stub!(:new).and_return(mock_team_consultation(:save => true))
        post :create, :team_consultation => {}, :format => 'html'
        response.should redirect_to(student_url(@mock_student))
      end
    end
    
    describe "with invalid params" do
      it "assigns a newly created but unsaved team_consultation as @team_consultation" do
        TeamConsultation.stub!(:new).with({'these' => 'params', 'student_id' => '2', 'requestor_id' => '3'}).and_return(mock_team_consultation(:save => false))
        post :create, :team_consultation => {:these => 'params'}
        assigns[:team_consultation].should equal(mock_team_consultation)
      end

      it "re-renders the 'new' template" do
        TeamConsultation.stub!(:new).and_return(mock_team_consultation(:save => false))
        post :create, :team_consultation => {}
        response.should render_template('new')
      end
    end
    
  end

  describe "PUT udpate" do
    
    describe "with valid params" do
      it "updates the requested team_consultation" do
        TeamConsultation.should_receive(:find).with("37").and_return(mock_team_consultation)
        mock_team_consultation.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :team_consultation => {:these => 'params'}
      end

      it "assigns the requested team_consultation as @team_consultation" do
        TeamConsultation.stub!(:find).and_return(mock_team_consultation(:update_attributes => true))
        put :update, :id => "1"
        assigns[:team_consultation].should equal(mock_team_consultation)
      end

      it "redirects to the team_consultation" do
        TeamConsultation.stub!(:find).and_return(mock_team_consultation(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(team_consultation_url(mock_team_consultation))
      end
    end
    
    describe "with invalid params" do
      it "updates the requested team_consultation" do
        TeamConsultation.should_receive(:find).with("37").and_return(mock_team_consultation)
        mock_team_consultation.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :team_consultation => {:these => 'params'}
      end

      it "assigns the team_consultation as @team_consultation" do
        TeamConsultation.stub!(:find).and_return(mock_team_consultation(:update_attributes => false))
        put :update, :id => "1"
        assigns[:team_consultation].should equal(mock_team_consultation)
      end

      it "re-renders the 'edit' template" do
        TeamConsultation.stub!(:find).and_return(mock_team_consultation(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end
    
  end

  describe "DELETE destroy" do
    it "destroys the requested team_consultation" do
      TeamConsultation.should_receive(:find).with("37").and_return(mock_team_consultation)
      mock_team_consultation.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "redirects to the team_consultations list" do
      TeamConsultation.stub!(:find).and_return(mock_team_consultation(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(team_consultations_url)
    end
  end

end
