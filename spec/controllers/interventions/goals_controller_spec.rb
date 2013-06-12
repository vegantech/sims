require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Interventions::GoalsController do
  it_should_behave_like "an authorized controller"
  include_context "authorized"
  include_context "authenticated"


  #Delete these examples and add some real ones
  it "should use Interventions::ObjectivesController" do
    controller.should be_an_instance_of(Interventions::GoalsController)
  end


  describe "POST 'create'" do
    it "should redirect to objective createion" do
      post 'create',:goal_id=>1
      response.should redirect_to(interventions_objectives_url(1))
    end
  end

  describe "xhr POST 'create'" do
    it "should display the objective createion dropdown" do
      controller.should_receive(:populate_objectives)
      xhr :post, 'create',:goal_id=>1
      response.should be_success
    end
  end
end
