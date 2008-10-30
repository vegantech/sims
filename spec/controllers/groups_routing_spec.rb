require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GroupsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "groups", :action => "index").should == "/groups"
    end
  
    it "should map #new" do
      route_for(:controller => "groups", :action => "new").should == "/groups/new"
    end
  
    it "should map #show" do
      route_for(:controller => "groups", :action => "show", :id => 1).should == "/groups/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "groups", :action => "edit", :id => 1).should == "/groups/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "groups", :action => "update", :id => 1).should == "/groups/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "groups", :action => "destroy", :id => 1).should == "/groups/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/groups").should == {:controller => "groups", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/groups/new").should == {:controller => "groups", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/groups").should == {:controller => "groups", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/groups/1").should == {:controller => "groups", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/groups/1/edit").should == {:controller => "groups", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/groups/1").should == {:controller => "groups", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/groups/1").should == {:controller => "groups", :action => "destroy", :id => "1"}
    end
  end
end
