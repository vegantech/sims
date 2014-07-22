require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe InterventionBuilder::ProbesController do
  describe "route generation" do
    it "should map #index" do
      route_for(controller: "intervention_builder/probes", action: "index").should == "/intervention_builder/probes"
    end
  
    it "should map #new" do
      route_for(controller: "intervention_builder/probes", action: "new").should == "/intervention_builder/probes/new"
    end
  
    it "should map #show" do
      route_for(controller: "intervention_builder/probes", action: "show", id: "1").should == "/intervention_builder/probes/1"
    end
  
    it "should map #edit" do
      route_for(controller: "intervention_builder/probes", action: "edit", id: "1").should == "/intervention_builder/probes/1/edit"
    end
  
    it "should map #update" do
      route_for(controller: "intervention_builder/probes", action: "update", id: "1").should == {path: "/intervention_builder/probes/1", method: :put}
    end
  
    it "should map #destroy" do
      route_for(controller: "intervention_builder/probes", action: "destroy", id: "1").should == {path: "/intervention_builder/probes/1", method: :delete}
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/intervention_builder/probes").should == {controller: "intervention_builder/probes", action: "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/intervention_builder/probes/new").should == {controller: "intervention_builder/probes", action: "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/intervention_builder/probes").should == {controller: "intervention_builder/probes", action: "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/intervention_builder/probes/1").should == {controller: "intervention_builder/probes", action: "show", id: "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/intervention_builder/probes/1/edit").should == {controller: "intervention_builder/probes", action: "edit", id: "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/intervention_builder/probes/1").should == {controller: "intervention_builder/probes", action: "update", id: "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/intervention_builder/probes/1").should == {controller: "intervention_builder/probes", action: "destroy", id: "1"}
    end
  end
end
