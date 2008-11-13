require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RolesController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "roles", :action => "index").should == "/roles"
    end
  
    it "should map #new" do
      route_for(:controller => "roles", :action => "new").should == "/roles/new"
    end
  
    it "should map #show" do
      route_for(:controller => "roles", :action => "show", :id => 1).should == "/roles/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "roles", :action => "edit", :id => 1).should == "/roles/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "roles", :action => "update", :id => 1).should == "/roles/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "roles", :action => "destroy", :id => 1).should == "/roles/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/roles").should == {:controller => "roles", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/roles/new").should == {:controller => "roles", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/roles").should == {:controller => "roles", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/roles/1").should == {:controller => "roles", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/roles/1/edit").should == {:controller => "roles", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/roles/1").should == {:controller => "roles", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/roles/1").should == {:controller => "roles", :action => "destroy", :id => "1"}
    end
  end
end
