require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Interventions::GoalsController do
  it_should_behave_like "an authorized controller"
  include_context "authorized"
  include_context "authenticated"


  #Delete these examples and add some real ones
  it "should use Interventions::ObjectivesController" do
    controller.should be_an_instance_of(Interventions::GoalsController)
  end


  describe "GET 'select'" do
    it "should redirect to objective selection" do
      get 'select',:goal_definition=>{:id=>1}
      response.should redirect_to(interventions_objectives_url(1))
    end
  end

  describe "xhr GET 'select'" do
    it "should display the objective selection dropdown" do
      controller.should_receive(:populate_objectives)
      xhr :get, 'select',:goal_definition=>{:id=>1}
      response.should be_success
    end
  end
end
