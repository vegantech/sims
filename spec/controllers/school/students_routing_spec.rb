require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe School::StudentsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "school/students", :action => "index").should == "/school/students"
    end
  
    it "should map #new" do
      route_for(:controller => "school/students", :action => "new").should == "/school/students/new"
    end
  
    it "should map #show" do
      route_for(:controller => "school/students", :action => "show", :id => "1").should == "/school/students/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "school/students", :action => "edit", :id => "1").should == "/school/students/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "school/students", :action => "update", :id => "1").should == "/school/students/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "school/students", :action => "destroy", :id => "1").should == "/school/students/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/school/students").should == {:controller => "school/students", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/school/students/new").should == {:controller => "school/students", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/school/students").should == {:controller => "school/students", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/school/students/1").should == {:controller => "school/students", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/school/students/1/edit").should == {:controller => "school/students", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/school/students/1").should == {:controller => "school/students", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/school/students/1").should == {:controller => "school/students", :action => "destroy", :id => "1"}
    end
  end
end
