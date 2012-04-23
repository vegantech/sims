require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe District::SchoolsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "district/schools", :action => "index").should == "/district/schools"
    end
  
    it "should map #new" do
      route_for(:controller => "district/schools", :action => "new").should == "/district/schools/new"
    end
  
    it "should map #show" do
      route_for(:controller => "district/schools", :action => "show", :id => "1").should == "/district/schools/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "district/schools", :action => "edit", :id => "1").should == "/district/schools/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "district/schools", :action => "update", :id => "1").should == {:path => "/district/schools/1", :method => :put}
    end
  
    it "should map #destroy" do
      route_for(:controller => "district/schools", :action => "destroy", :id => "1").should == {:path => "/district/schools/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/district/schools").should == {:controller => "district/schools", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/district/schools/new").should == {:controller => "district/schools", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/district/schools").should == {:controller => "district/schools", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/district/schools/1").should == {:controller => "district/schools", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/district/schools/1/edit").should == {:controller => "district/schools", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/district/schools/1").should == {:controller => "district/schools", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/district/schools/1").should == {:controller => "district/schools", :action => "destroy", :id => "1"}
    end
  end
end
