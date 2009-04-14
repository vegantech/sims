require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe District::UsersController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "district/users", :action => "index").should == "/district/users"
    end
  
    it "should map #new" do
      route_for(:controller => "district/users", :action => "new").should == "/district/users/new"
    end
  
    it "should map #show" do
      route_for(:controller => "district/users", :action => "show", :id => "1").should == "/district/users/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "district/users", :action => "edit", :id => "1").should == "/district/users/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "district/users", :action => "update", :id => "1").should == "/district/users/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "district/users", :action => "destroy", :id => "1").should == "/district/users/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/district/users").should == {:controller => "district/users", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/district/users/new").should == {:controller => "district/users", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/district/users").should == {:controller => "district/users", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/district/users/1").should == {:controller => "district/users", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/district/users/1/edit").should == {:controller => "district/users", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/district/users/1").should == {:controller => "district/users", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/district/users/1").should == {:controller => "district/users", :action => "destroy", :id => "1"}
    end
  end
end
