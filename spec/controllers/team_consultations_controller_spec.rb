require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TeamConsultationsController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"
  it_should_behave_like "a schools_requiring controller"
      

  def mock_team_consultation(stubs={})
    stubs.reverse_merge!(:draft? =>false, :student => mock_student)
    @mock_team_consultation ||= mock_model(TeamConsultation, stubs)
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
      mock_team_consultation.stub!(:build_consultation_form => true, :consultation_forms=>[1], :school_team => 'A')
      controller.stub_association!(:current_school, :school_teams => [])
      TeamConsultation.should_receive(:new).and_return(mock_team_consultation)
      get :new
      assigns[:team_consultation].should equal(mock_team_consultation)
    end
  end

  describe "GET edit" do
    it "assigns the requested team_consultation as @team_consultation" do
      TeamConsultation.should_receive(:find).with("37").and_return(mock_team_consultation)
      controller.stub_association!(:current_school, :school_teams => [])
      get :edit, :id => "37"
      assigns[:team_consultation].should equal(mock_team_consultation)
    end
  end

  describe "POST create" do
    before do
      @mock_student = mock_student
      controller.stub!(:current_student_id => '2', :current_user_id => '3', :current_student => @mock_student)
      controller.stub_association!(:current_school, :school_teams => [])
    end
    
    describe "with valid params" do
      it "assigns a newly created team_consultation as @team_consultation" do
        TeamConsultation.should_receive(:new).with({'these' => 'params', 'student_id' => '2', 'requestor_id' => '3'}).and_return(mock_team_consultation(:save => true,  :school_team => 'A'))
        post :create, :team_consultation => {:these => 'params'}
        assigns[:team_consultation].should equal(mock_team_consultation)
      end

      it "redirects back to the student profile" do
        TeamConsultation.stub!(:new).and_return(mock_team_consultation(:save => true, :recipient => 'Bob', :school_team => 'A'))
        post :create, :team_consultation => {}, :format => 'html'
        response.should redirect_to(student_url(@mock_student))
      end
    end
    
    describe "with invalid params" do
      it "assigns a newly created but unsaved team_consultation as @team_consultation" do
        TeamConsultation.stub!(:new).with({'these' => 'params', 'student_id' => '2', 'requestor_id' => '3'}).and_return(mock_team_consultation(:save => false, :school_team => 'A'))
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

  describe "PUT update" do
    
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

      it "behaves like create" do
        @student = mock_student
        TeamConsultation.stub!(:find).and_return(mock_team_consultation(:update_attributes => true, :student => @student))
        put :update, :id => "1"
        response.should redirect_to(student_url(@student))
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
        response.should render_template('new')
      end
    end
    
  end

  describe "DELETE destroy" do
    it "destroys the requested team_consultation" do
      TeamConsultation.should_receive(:find).with("37",anything()).and_return(mock_team_consultation)
      mock_team_consultation.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "redirects to the team_consultations list (student)" do
      TeamConsultation.stub!(:find).and_return(mock_team_consultation(:destroy => true, :student => stu=mock_student))
      delete :destroy, :id => "1", :format =>'html'
      response.should redirect_to(student_url(stu))
    end
  end

end
