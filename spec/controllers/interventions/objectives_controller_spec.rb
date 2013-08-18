require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Interventions::ObjectivesController do
  it_should_behave_like "an authorized controller"
  include_context "authorized"
  include_context "authenticated"


  #Delete these examples and add some real ones
  it "should use Interventions::ObjectivesController" do
    controller.should be_an_instance_of(Interventions::ObjectivesController)
  end


  describe "GET 'index'" do
    it "should be successful" do
      controller.should_receive(:populate_goals)
      get 'index',:goal_id=>1
      response.should be_success
    end
  end

  describe "post create'" do
    it "should redirect to category selection" do
      post 'create',:goal_id=>1,:objective_id=>1
      response.should redirect_to(interventions_categories_url(1,1))
    end
  end

  describe "xhr POST 'create'" do
    it "should display the category selection dropdown" do
      controller.should_receive(:populate_categories)
      xhr :post, 'create',:goal_id=>1,:objective_id=>1
      response.should be_success
    end
  end
end

