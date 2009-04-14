require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe InterventionBuilder::InterventionsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "intervention_builder/interventions", :action => "index", :goal_id => "1", :objective_id => "1", :category_id => "1").should == "/intervention_builder/goals/1/objectives/1/categories/1/interventions"
    end
  
    it "should map #new" do
      route_for(:controller => "intervention_builder/interventions", :action => "new", :goal_id => "1", :objective_id => "1", :category_id => "1").should == "/intervention_builder/goals/1/objectives/1/categories/1/interventions/new"
    end
  
    it "should map #show" do
      route_for(:controller => "intervention_builder/interventions", :action => "show", :id => "1", :goal_id => "1", :objective_id => "1", :category_id => "1").should == "/intervention_builder/goals/1/objectives/1/categories/1/interventions/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "intervention_builder/interventions", :action => "edit", :id => "1", :goal_id => "1", :objective_id => "1", :category_id => "1").should == "/intervention_builder/goals/1/objectives/1/categories/1/interventions/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "intervention_builder/interventions", :action => "update", :id => "1", :goal_id => "1", :objective_id => "1", :category_id => "1").should == "/intervention_builder/goals/1/objectives/1/categories/1/interventions/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "intervention_builder/interventions", :action => "destroy", :id => "1", :goal_id => "1", :objective_id => "1", :category_id => "1").should == "/intervention_builder/goals/1/objectives/1/categories/1/interventions/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/intervention_builder/goals/1/objectives/1/categories/1/interventions").should == {:controller => "intervention_builder/interventions", :action => "index", :goal_id => "1", :objective_id => "1", :category_id => "1"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/intervention_builder/goals/1/objectives/1/categories/1/interventions/new").should == {:controller => "intervention_builder/interventions", :action => "new", :goal_id => "1", :objective_id => "1", :category_id => "1"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/intervention_builder/goals/1/objectives/1/categories/1/interventions").should == {:controller => "intervention_builder/interventions", :action => "create", :goal_id => "1", :objective_id => "1", :category_id => "1"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/intervention_builder/goals/1/objectives/1/categories/1/interventions/1").should == {:controller => "intervention_builder/interventions", :action => "show", :id => "1", :goal_id => "1", :objective_id => "1", :category_id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/intervention_builder/goals/1/objectives/1/categories/1/interventions/1/edit").should == {:controller => "intervention_builder/interventions", :action => "edit", :id => "1", :goal_id => "1", :objective_id => "1", :category_id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/intervention_builder/goals/1/objectives/1/categories/1/interventions/1").should == {:controller => "intervention_builder/interventions", :action => "update", :id => "1", :goal_id => "1", :objective_id => "1", :category_id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/intervention_builder/goals/1/objectives/1/categories/1/interventions/1").should == {:controller => "intervention_builder/interventions", :action => "destroy", :id => "1", :goal_id => "1", :objective_id => "1", :category_id => "1"}
    end
  end
end
