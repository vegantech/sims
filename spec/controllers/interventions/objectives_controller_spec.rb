require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Interventions::ObjectivesController do

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

  describe "GET 'select'" do
    it "should redirect to category selection" do
      get 'select',:goal_id=>1,:objective_definition=>{:id=>1}
      response.should redirect_to(interventions_categories_url(1,1))
    end
  end

  describe "xhr GET 'select'" do
    it "should display the category selection dropdown" do
      controller.should_receive(:populate_categories)
      xhr :get, 'select',:goal_id=>1,:objective_definition=>{:id=>1}
      response.should be_success
    end
  end
end

