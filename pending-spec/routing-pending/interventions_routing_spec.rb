require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InterventionsController do
  describe "route generation" do
    it "should map #index" do
      route_for(controller: "interventions", action: "index").should == "/interventions"
    end
  
    it "should map #new" do
      route_for(controller: "interventions", action: "new").should == "/interventions/new"
    end
  
    it "should map #show" do
      route_for(controller: "interventions", action: "show", id: "1").should == "/interventions/1"
    end
  
    it "should map #edit" do
      route_for(controller: "interventions", action: "edit", id: "1").should == "/interventions/1/edit"
    end
  
    it "should map #update" do
      route_for(controller: "interventions", action: "update", id: "1").should == {path: "/interventions/1", method: :put}
    end
  
    it "should map #destroy" do
      route_for(controller: "interventions", action: "destroy", id: "1").should == {path: "/interventions/1", method: :delete}
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/interventions").should == {controller: "interventions", action: "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/interventions/new").should == {controller: "interventions", action: "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/interventions").should == {controller: "interventions", action: "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/interventions/1").should == {controller: "interventions", action: "show", id: "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/interventions/1/edit").should == {controller: "interventions", action: "edit", id: "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/interventions/1").should == {controller: "interventions", action: "update", id: "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/interventions/1").should == {controller: "interventions", action: "destroy", id: "1"}
    end
  end
end
