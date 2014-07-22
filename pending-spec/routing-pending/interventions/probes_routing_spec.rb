require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Interventions::ProbesController do
  describe "route generation" do
    it "should map #index" do 
      pending
      route_for(controller: "probes", action: "index").should == "/probes"
    end
  
    it "should map #new" do 
      pending
      route_for(controller: "probes", action: "new").should == "/probes/new"
    end
  
    it "should map #show" do 
      pending
      route_for(controller: "probes", action: "show", id: "1").should == "/probes/1"
    end
  
    it "should map #edit" do 
      pending
      route_for(controller: "probes", action: "edit", id: "1").should == "/probes/1/edit"
    end
  
    it "should map #update" do 
      pending
      route_for(controller: "probes", action: "update", id: "1").should == "/probes/1"
    end
  
    it "should map #destroy" do 
      pending
      route_for(controller: "probes", action: "destroy", id: "1").should == "/probes/1"
    end
  end

  describe "route recognition" do 
    it "should generate params for #index" do 
      pending
      params_from(:get, "/probes").should == {controller: "probes", action: "index"}
    end
  
    it "should generate params for #new" do 
      pending
      params_from(:get, "/probes/new").should == {controller: "probes", action: "new"}
    end
  
    it "should generate params for #create" do 
      pending
      params_from(:post, "/probes").should == {controller: "probes", action: "create"}
    end
  
    it "should generate params for #show" do 
      pending
      params_from(:get, "/probes/1").should == {controller: "probes", action: "show", id: "1"}
    end
  
    it "should generate params for #edit" do 
      pending
      params_from(:get, "/probes/1/edit").should == {controller: "probes", action: "edit", id: "1"}
    end
  
    it "should generate params for #update" do 
      pending
      params_from(:put, "/probes/1").should == {controller: "probes", action: "update", id: "1"}
    end
  
    it "should generate params for #destroy" do 
      pending
      params_from(:delete, "/probes/1").should == {controller: "probes", action: "destroy", id: "1"}
    end
  end
end
