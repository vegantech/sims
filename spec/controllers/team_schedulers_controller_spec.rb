require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TeamSchedulersController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"

  def mock_team_scheduler(stubs={})
    @mock_team_scheduler ||= mock_model(TeamScheduler, stubs)
  end
  
  describe "GET index" do
    it "assigns all team_schedulers as @team_schedulers" do
      TeamScheduler.should_receive(:find).with(:all).and_return([mock_team_scheduler])
      get :index
      assigns[:team_schedulers].should == [mock_team_scheduler]
    end
  end

  describe "GET show" do
    it "assigns the requested team_scheduler as @team_scheduler" do
      TeamScheduler.should_receive(:find).with("37").and_return(mock_team_scheduler)
      get :show, :id => "37"
      assigns[:team_scheduler].should equal(mock_team_scheduler)
    end
  end

  describe "GET new" do
    it "assigns a new team_scheduler as @team_scheduler" do
      TeamScheduler.should_receive(:new).and_return(mock_team_scheduler)
      get :new
      assigns[:team_scheduler].should equal(mock_team_scheduler)
    end
  end

  describe "GET edit" do
    it "assigns the requested team_scheduler as @team_scheduler" do
      TeamScheduler.should_receive(:find).with("37").and_return(mock_team_scheduler)
      get :edit, :id => "37"
      assigns[:team_scheduler].should equal(mock_team_scheduler)
    end
  end

  describe "POST create" do
    
    describe "with valid params" do
      it "assigns a newly created team_scheduler as @team_scheduler" do
        TeamScheduler.should_receive(:new).with({'these' => 'params'}).and_return(mock_team_scheduler(:save => true))
        post :create, :team_scheduler => {:these => 'params'}
        assigns[:team_scheduler].should equal(mock_team_scheduler)
      end

      it "redirects to the created team_scheduler" do
        TeamScheduler.stub!(:new).and_return(mock_team_scheduler(:save => true))
        post :create, :team_scheduler => {}
        response.should redirect_to(team_scheduler_url(mock_team_scheduler))
      end
    end
    
    describe "with invalid params" do
      it "assigns a newly created but unsaved team_scheduler as @team_scheduler" do
        TeamScheduler.stub!(:new).with({'these' => 'params'}).and_return(mock_team_scheduler(:save => false))
        post :create, :team_scheduler => {:these => 'params'}
        assigns[:team_scheduler].should equal(mock_team_scheduler)
      end

      it "re-renders the 'new' template" do
        TeamScheduler.stub!(:new).and_return(mock_team_scheduler(:save => false))
        post :create, :team_scheduler => {}
        response.should render_template('new')
      end
    end
    
  end

  describe "PUT udpate" do
    
    describe "with valid params" do
      it "updates the requested team_scheduler" do
        TeamScheduler.should_receive(:find).with("37").and_return(mock_team_scheduler)
        mock_team_scheduler.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :team_scheduler => {:these => 'params'}
      end

      it "assigns the requested team_scheduler as @team_scheduler" do
        TeamScheduler.stub!(:find).and_return(mock_team_scheduler(:update_attributes => true))
        put :update, :id => "1"
        assigns[:team_scheduler].should equal(mock_team_scheduler)
      end

      it "redirects to the team_scheduler" do
        TeamScheduler.stub!(:find).and_return(mock_team_scheduler(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(team_scheduler_url(mock_team_scheduler))
      end
    end
    
    describe "with invalid params" do
      it "updates the requested team_scheduler" do
        TeamScheduler.should_receive(:find).with("37").and_return(mock_team_scheduler)
        mock_team_scheduler.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :team_scheduler => {:these => 'params'}
      end

      it "assigns the team_scheduler as @team_scheduler" do
        TeamScheduler.stub!(:find).and_return(mock_team_scheduler(:update_attributes => false))
        put :update, :id => "1"
        assigns[:team_scheduler].should equal(mock_team_scheduler)
      end

      it "re-renders the 'edit' template" do
        TeamScheduler.stub!(:find).and_return(mock_team_scheduler(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end
    
  end

  describe "DELETE destroy" do
    it "destroys the requested team_scheduler" do
      TeamScheduler.should_receive(:find).with("37").and_return(mock_team_scheduler)
      mock_team_scheduler.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "redirects to the team_schedulers list" do
      TeamScheduler.stub!(:find).and_return(mock_team_scheduler(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(team_schedulers_url)
    end
  end

end
