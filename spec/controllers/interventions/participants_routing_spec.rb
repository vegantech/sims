require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InterventionParticipantsController do
  describe "route generation" do
    it "should map #index" do
      pending
      route_for(:controller => "intervention_participants", :action => "index").should == "/intervention_participants"
    end
  
    it "should map #new" do
      pending
      route_for(:controller => "intervention_participants", :action => "new").should == "/intervention_participants/new"
    end
  
    it "should map #show" do
      pending
      route_for(:controller => "intervention_participants", :action => "show", :id => 1).should == "/intervention_participants/1"
    end
  
    it "should map #edit" do
      pending
      route_for(:controller => "intervention_participants", :action => "edit", :id => 1).should == "/intervention_participants/1/edit"
    end
  
    it "should map #update" do
      pending
      route_for(:controller => "intervention_participants", :action => "update", :id => 1).should == "/intervention_participants/1"
    end
  
    it "should map #destroy" do
      pending
      route_for(:controller => "intervention_participants", :action => "destroy", :id => 1).should == "/intervention_participants/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      pending
      params_from(:get, "/intervention_participants").should == {:controller => "intervention_participants", :action => "index"}
    end
  
    it "should generate params for #new" do
      pending
      params_from(:get, "/intervention_participants/new").should == {:controller => "intervention_participants", :action => "new"}
    end
  
    it "should generate params for #create" do
      pending
      params_from(:post, "/intervention_participants").should == {:controller => "intervention_participants", :action => "create"}
    end
  
    it "should generate params for #show" do
      pending
      params_from(:get, "/intervention_participants/1").should == {:controller => "intervention_participants", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      pending
      params_from(:get, "/intervention_participants/1/edit").should == {:controller => "intervention_participants", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      pending
      params_from(:put, "/intervention_participants/1").should == {:controller => "intervention_participants", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      pending
      params_from(:delete, "/intervention_participants/1").should == {:controller => "intervention_participants", :action => "destroy", :id => "1"}
    end
  end
end
