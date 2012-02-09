require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Interventions::DefinitionsController do
  it_should_behave_like "an authorized controller"
  include_context "authorized"
  include_context "authenticated"


  #Delete these examples and add some real ones
  it "should use Interventions::DefinitionsController" do
    controller.should be_an_instance_of(Interventions::DefinitionsController)
  end


  describe "GET 'index'" do
    it "should be successful" do
      controller.should_receive(:populate_goals)
      get 'index',:goal_id=>1,:objective_id=>1,:category_id=>1
      response.should be_success
    end
  end


  describe "GET 'select'" do
    it "should redirect to new intervention screen" do
      get 'select',:goal_id=>1,:objective_id=>1,:category_id=>1,:intervention_definition=>{:id=>1}
      response.should redirect_to(new_intervention_url(:category_id=>1,:definition_id=>1,:goal_id=>1,:objective_id=>1))
    end
  end

  describe "xhr GET 'select'" do
    it "should display the definition selection dropdown" do
      controller.should_receive(:populate_intervention)
      xhr :get, 'select',:goal_id=>1,:objective_id=>1,:category_id=>1,:intervention_definition=>{:id=>1}
      response.should be_success
    end
  end
end

