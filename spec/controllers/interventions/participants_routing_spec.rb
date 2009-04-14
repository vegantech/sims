require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Interventions::ParticipantsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "interventions/participants", :intervention_id => "2", :action => "index").should == "/interventions/2/participants"
    end
  
    it "should map #new" do
      route_for(:controller => "interventions/participants", :intervention_id => "2", :action => "new").should == "/interventions/2/participants/new"
    end
  
    it "should map #show" do
      route_for(:controller => "interventions/participants", :intervention_id => "2", :action => "show", :id => "1").should == "/interventions/2/participants/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "interventions/participants", :intervention_id => "2", :action => "edit", :id => "1").should == "/interventions/2/participants/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "interventions/participants", :intervention_id => "2", :action => "update", :id => "1").should == "/interventions/2/participants/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "interventions/participants", :intervention_id => "2", :action => "destroy", :id => "1").should == "/interventions/2/participants/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/interventions/2/participants").should == {:controller => "interventions/participants", :intervention_id => "2", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/interventions/2/participants/new").should == {:controller => "interventions/participants", :intervention_id => "2", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/interventions/2/participants").should == {:controller => "interventions/participants", :intervention_id => "2", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/interventions/2/participants/1").should == {:controller => "interventions/participants", :intervention_id => "2", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/interventions/2/participants/1/edit").should == {:controller => "interventions/participants", :intervention_id => "2", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/interventions/2/participants/1").should == {:controller => "interventions/participants", :intervention_id => "2", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/interventions/2/participants/1").should == {:controller => "interventions/participants", :intervention_id => "2", :action => "destroy", :id => "1"}
    end
  end
end
