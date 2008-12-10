require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CustomProbesController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "custom_probes", :action => "index").should == "/custom_probes"
    end
  
    it "should map #new" do
      route_for(:controller => "custom_probes", :action => "new").should == "/custom_probes/new"
    end
  
    it "should map #show" do
      route_for(:controller => "custom_probes", :action => "show", :id => 1).should == "/custom_probes/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "custom_probes", :action => "edit", :id => 1).should == "/custom_probes/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "custom_probes", :action => "update", :id => 1).should == "/custom_probes/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "custom_probes", :action => "destroy", :id => 1).should == "/custom_probes/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/custom_probes").should == {:controller => "custom_probes", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/custom_probes/new").should == {:controller => "custom_probes", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/custom_probes").should == {:controller => "custom_probes", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/custom_probes/1").should == {:controller => "custom_probes", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/custom_probes/1/edit").should == {:controller => "custom_probes", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/custom_probes/1").should == {:controller => "custom_probes", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/custom_probes/1").should == {:controller => "custom_probes", :action => "destroy", :id => "1"}
    end
  end
end
