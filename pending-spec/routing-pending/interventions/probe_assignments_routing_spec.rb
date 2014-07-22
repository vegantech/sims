require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Interventions::ProbeAssignmentsController do
  describe "route generation" do
    it "should map #index" do
      pending
      route_for(controller: "intervention_probe_assignments", action: "index").should == "/intervention_probe_assignments"
    end
  
 end

  describe "route recognition" do
    it "should generate params for #index" do
      pending
      params_from(:get, "/intervention_probe_assignments").should == {controller: "intervention_probe_assignments", action: "index"}
    end
  
  end
  
end
