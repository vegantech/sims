require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TeamSchedulersController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"

 
  describe "GET index" do
    it "shows list of users for school with checkboxes for team_schedulers" do
      controller.stub_association!(:current_school, :users => [1,2,3,4])
      get :index
      assigns[:users_in_groups].should == [[1,2,3],[4]]
    end
  end

  describe "POST create" do
    
    describe "with valid params" do
      it "sets the team_schedulers for the school" do
        
        controller.should_receive(:current_school).and_return(m=mock_school)
        m.should_receive(:team_scheduler_user_ids=).with(["1","2","3"])
        post :create, :user_ids => ["1", "2", "3"]
        response.should redirect_to(team_schedulers_url)
      end

      it "clears the team_schedulers when none are checked" do
        controller.should_receive(:current_school).and_return(m=mock_school)
        m.should_receive(:team_scheduler_user_ids=).with([])
        post :create
        response.should redirect_to(team_schedulers_url)
      end
    end
    
   
  end

end
