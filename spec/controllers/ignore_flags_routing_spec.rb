require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe IgnoreFlagsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "ignore_flags", :action => "index").should == "/ignore_flags"
    end
  
    it "should map #new" do
      route_for(:controller => "ignore_flags", :action => "new").should == "/ignore_flags/new"
    end
  
    it "should map #show" do
      route_for(:controller => "ignore_flags", :action => "show", :id => 1).should == "/ignore_flags/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "ignore_flags", :action => "edit", :id => 1).should == "/ignore_flags/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "ignore_flags", :action => "update", :id => 1).should == "/ignore_flags/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "ignore_flags", :action => "destroy", :id => 1).should == "/ignore_flags/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/ignore_flags").should == {:controller => "ignore_flags", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/ignore_flags/new").should == {:controller => "ignore_flags", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/ignore_flags").should == {:controller => "ignore_flags", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/ignore_flags/1").should == {:controller => "ignore_flags", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/ignore_flags/1/edit").should == {:controller => "ignore_flags", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/ignore_flags/1").should == {:controller => "ignore_flags", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/ignore_flags/1").should == {:controller => "ignore_flags", :action => "destroy", :id => "1"}
    end
  end
end
