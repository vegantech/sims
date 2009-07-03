require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TeamAgendasController do

  def mock_team_agenda(stubs={})
    @mock_team_agenda ||= mock_model(TeamAgenda, stubs)
  end
  
  describe "GET index" do
    it "assigns all team_agendas as @team_agendas" do
      TeamAgenda.should_receive(:find).with(:all).and_return([mock_team_agenda])
      get :index
      assigns[:team_agendas].should == [mock_team_agenda]
    end
  end

  describe "GET show" do
    it "assigns the requested team_agenda as @team_agenda" do
      TeamAgenda.should_receive(:find).with("37").and_return(mock_team_agenda)
      get :show, :id => "37"
      assigns[:team_agenda].should equal(mock_team_agenda)
    end
  end

  describe "GET new" do
    it "assigns a new team_agenda as @team_agenda" do
      TeamAgenda.should_receive(:new).and_return(mock_team_agenda)
      get :new
      assigns[:team_agenda].should equal(mock_team_agenda)
    end
  end

  describe "GET edit" do
    it "assigns the requested team_agenda as @team_agenda" do
      TeamAgenda.should_receive(:find).with("37").and_return(mock_team_agenda)
      get :edit, :id => "37"
      assigns[:team_agenda].should equal(mock_team_agenda)
    end
  end

  describe "POST create" do
    
    describe "with valid params" do
      it "assigns a newly created team_agenda as @team_agenda" do
        TeamAgenda.should_receive(:new).with({'these' => 'params'}).and_return(mock_team_agenda(:save => true))
        post :create, :team_agenda => {:these => 'params'}
        assigns[:team_agenda].should equal(mock_team_agenda)
      end

      it "redirects to the created team_agenda" do
        TeamAgenda.stub!(:new).and_return(mock_team_agenda(:save => true))
        post :create, :team_agenda => {}
        response.should redirect_to(team_agenda_url(mock_team_agenda))
      end
    end
    
    describe "with invalid params" do
      it "assigns a newly created but unsaved team_agenda as @team_agenda" do
        TeamAgenda.stub!(:new).with({'these' => 'params'}).and_return(mock_team_agenda(:save => false))
        post :create, :team_agenda => {:these => 'params'}
        assigns[:team_agenda].should equal(mock_team_agenda)
      end

      it "re-renders the 'new' template" do
        TeamAgenda.stub!(:new).and_return(mock_team_agenda(:save => false))
        post :create, :team_agenda => {}
        response.should render_template('new')
      end
    end
    
  end

  describe "PUT udpate" do
    
    describe "with valid params" do
      it "updates the requested team_agenda" do
        TeamAgenda.should_receive(:find).with("37").and_return(mock_team_agenda)
        mock_team_agenda.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :team_agenda => {:these => 'params'}
      end

      it "assigns the requested team_agenda as @team_agenda" do
        TeamAgenda.stub!(:find).and_return(mock_team_agenda(:update_attributes => true))
        put :update, :id => "1"
        assigns[:team_agenda].should equal(mock_team_agenda)
      end

      it "redirects to the team_agenda" do
        TeamAgenda.stub!(:find).and_return(mock_team_agenda(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(team_agenda_url(mock_team_agenda))
      end
    end
    
    describe "with invalid params" do
      it "updates the requested team_agenda" do
        TeamAgenda.should_receive(:find).with("37").and_return(mock_team_agenda)
        mock_team_agenda.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :team_agenda => {:these => 'params'}
      end

      it "assigns the team_agenda as @team_agenda" do
        TeamAgenda.stub!(:find).and_return(mock_team_agenda(:update_attributes => false))
        put :update, :id => "1"
        assigns[:team_agenda].should equal(mock_team_agenda)
      end

      it "re-renders the 'edit' template" do
        TeamAgenda.stub!(:find).and_return(mock_team_agenda(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end
    
  end

  describe "DELETE destroy" do
    it "destroys the requested team_agenda" do
      TeamAgenda.should_receive(:find).with("37").and_return(mock_team_agenda)
      mock_team_agenda.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "redirects to the team_agendas list" do
      TeamAgenda.stub!(:find).and_return(mock_team_agenda(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(team_agendas_url)
    end
  end

end
