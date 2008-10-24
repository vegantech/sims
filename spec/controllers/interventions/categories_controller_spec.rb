require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Interventions::CategoriesController do

  #Delete these examples and add some real ones
  it "should use Interventions::CategoriesController" do
    controller.should be_an_instance_of(Interventions::CategoriesController)
  end

  describe "GET 'index'" do
    it "should be successful" do
      controller.should_receive(:populate_goals)
      get 'index',:goal_id=>1,:objective_id=>1
      response.should be_success
    end
  end


  describe "GET 'select'" do
    it "should redirect to definition selection" do
      get 'select',:goal_id=>1,:objective_id=>1,:intervention_cluster=>{:id=>1}
      response.should redirect_to(interventions_definitions_url(1,1,1))
    end
  end

  describe "xhr GET 'select'" do
    it "should display the definition selection dropdown" do
      controller.should_receive(:populate_definitions)
      xhr :get, 'select',:goal_id=>1,:objective_id=>1,:intervention_cluster=>{:id=>1}
      response.should be_success
    end
  end
end
