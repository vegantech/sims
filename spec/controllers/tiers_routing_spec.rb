require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TiersController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "tiers", :action => "index").should == "/tiers"
    end
  
    it "should map #new" do
      route_for(:controller => "tiers", :action => "new").should == "/tiers/new"
    end
  
    it "should map #show" do
      route_for(:controller => "tiers", :action => "show", :id => 1).should == "/tiers/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "tiers", :action => "edit", :id => 1).should == "/tiers/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "tiers", :action => "update", :id => 1).should == "/tiers/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "tiers", :action => "destroy", :id => 1).should == "/tiers/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/tiers").should == {:controller => "tiers", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/tiers/new").should == {:controller => "tiers", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/tiers").should == {:controller => "tiers", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/tiers/1").should == {:controller => "tiers", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/tiers/1/edit").should == {:controller => "tiers", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/tiers/1").should == {:controller => "tiers", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/tiers/1").should == {:controller => "tiers", :action => "destroy", :id => "1"}
    end
  end
end
