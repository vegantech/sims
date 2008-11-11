require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PrincipalOverridesController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "principal_overrides", :action => "index").should == "/principal_overrides"
    end
  
    it "should map #new" do
      route_for(:controller => "principal_overrides", :action => "new").should == "/principal_overrides/new"
    end
  
    it "should map #show" do
      route_for(:controller => "principal_overrides", :action => "show", :id => 1).should == "/principal_overrides/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "principal_overrides", :action => "edit", :id => 1).should == "/principal_overrides/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "principal_overrides", :action => "update", :id => 1).should == "/principal_overrides/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "principal_overrides", :action => "destroy", :id => 1).should == "/principal_overrides/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/principal_overrides").should == {:controller => "principal_overrides", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/principal_overrides/new").should == {:controller => "principal_overrides", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/principal_overrides").should == {:controller => "principal_overrides", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/principal_overrides/1").should == {:controller => "principal_overrides", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/principal_overrides/1/edit").should == {:controller => "principal_overrides", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/principal_overrides/1").should == {:controller => "principal_overrides", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/principal_overrides/1").should == {:controller => "principal_overrides", :action => "destroy", :id => "1"}
    end
  end
end
