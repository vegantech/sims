require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SchoolTeamsController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"

  def mock_school_team(stubs={})
    @mock_school_team ||= mock_model(SchoolTeam, stubs)
  end

  before do
    controller.stub_association!(:current_school, :school_teams =>SchoolTeam, :assigned_users=>[1,2,3,4])
  end
  
  describe "GET index" do
    it "assigns all school_teams as @school_teams" do
      SchoolTeam.should_receive(:find).with(:all).and_return([mock_school_team])
      get :index
      assigns[:school_teams].should == [mock_school_team]
    end
  end

  describe "GET show" do
    it "assigns the requested school_team as @school_team" do
      SchoolTeam.should_receive(:find).with("37").and_return(mock_school_team)
      get :show, :id => "37"
      assigns[:school_team].should equal(mock_school_team)
    end
  end

  describe "GET new" do
    it "assigns a new school_team as @school_team" do
      SchoolTeam.should_receive(:new).and_return(mock_school_team)
      get :new
      assigns[:school_team].should equal(mock_school_team)
    end
  end

  describe "GET edit" do
    it "assigns the requested school_team as @school_team" do
      SchoolTeam.should_receive(:find).with("37").and_return(mock_school_team)
      get :edit, :id => "37"
      assigns[:school_team].should equal(mock_school_team)
    end
  end

  describe "POST create" do
    
    describe "with valid params" do
      it "assigns a newly created school_team as @school_team" do
        SchoolTeam.should_receive(:build).with({'these' => 'params'}).and_return(mock_school_team(:save => true))
        post :create, :school_team => {:these => 'params'}
        assigns[:school_team].should equal(mock_school_team)
      end

      it "redirects to the school_team index" do
        SchoolTeam.stub!(:build).and_return(mock_school_team(:save => true))
        post :create, :school_team => {}
        response.should redirect_to(school_teams_url)
      end

      it "provides a link to the created school_team" do
        SchoolTeam.stub!(:build).and_return(mock_school_team(:save => true))
        post :create, :school_team => {}
        flash[:notice].should match(/#{edit_school_team_path(mock_school_team)}/)
      end


    end
    
    describe "with invalid params" do
      it "assigns a newly created but unsaved school_team as @school_team" do
        SchoolTeam.stub!(:build).with({'these' => 'params'}).and_return(mock_school_team(:save => false))
        post :create, :school_team => {:these => 'params'}
        assigns[:school_team].should equal(mock_school_team)
      end

      it "re-renders the 'new' template" do
        SchoolTeam.stub!(:build).and_return(mock_school_team(:save => false))
        post :create, :school_team => {}
        response.should render_template('new')
      end
    end
    
  end

  describe "PUT udpate" do
    
    describe "with valid params" do
      it "updates the requested school_team" do
        SchoolTeam.should_receive(:find).with("37").and_return(mock_school_team)
        mock_school_team.should_receive(:update_attributes).with({'these' => 'params', "user_ids"=>[]})
        put :update, :id => "37", :school_team => {:these => 'params'}
      end

      it "assigns the requested school_team as @school_team" do
        SchoolTeam.stub!(:find).and_return(mock_school_team(:update_attributes => true))
        put :update, :id => "1"
        assigns[:school_team].should equal(mock_school_team)
      end

      it "redirects to the school_team" do
        SchoolTeam.stub!(:find).and_return(mock_school_team(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(school_teams_url)
      end

      it "provides a link to the edited school_team" do
        SchoolTeam.stub!(:find).and_return(mock_school_team(:update_attributes => true))
        put :update, :id => "1"
        flash[:notice].should match(/#{edit_school_team_path(mock_school_team)}/)
      end

    end
    
    describe "with invalid params" do
      it "updates the requested school_team" do
        SchoolTeam.should_receive(:find).with("37").and_return(mock_school_team)
        mock_school_team.should_receive(:update_attributes).with({'these' => 'params', "user_ids"=>[]})
        put :update, :id => "37", :school_team => {:these => 'params'}
      end

      it "assigns the school_team as @school_team" do
        SchoolTeam.stub!(:find).and_return(mock_school_team(:update_attributes => false))
        put :update, :id => "1"
        assigns[:school_team].should equal(mock_school_team)
      end

      it "re-renders the 'edit' template" do
        SchoolTeam.stub!(:find).and_return(mock_school_team(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end
    
  end

  describe "DELETE destroy" do
    it "destroys the requested school_team" do
      SchoolTeam.should_receive(:find).with("37").and_return(mock_school_team)
      mock_school_team.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "redirects to the school_teams list" do
      SchoolTeam.stub!(:find).and_return(mock_school_team(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(school_teams_url)
    end
  end

end
