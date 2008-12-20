require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UserSchoolAssignmentsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "user_school_assignments", :action => "index").should == "/user_school_assignments"
    end
  
    it "should map #new" do
      route_for(:controller => "user_school_assignments", :action => "new").should == "/user_school_assignments/new"
    end
  
    it "should map #show" do
      route_for(:controller => "user_school_assignments", :action => "show", :id => 1).should == "/user_school_assignments/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "user_school_assignments", :action => "edit", :id => 1).should == "/user_school_assignments/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "user_school_assignments", :action => "update", :id => 1).should == "/user_school_assignments/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "user_school_assignments", :action => "destroy", :id => 1).should == "/user_school_assignments/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/user_school_assignments").should == {:controller => "user_school_assignments", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/user_school_assignments/new").should == {:controller => "user_school_assignments", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/user_school_assignments").should == {:controller => "user_school_assignments", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/user_school_assignments/1").should == {:controller => "user_school_assignments", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/user_school_assignments/1/edit").should == {:controller => "user_school_assignments", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/user_school_assignments/1").should == {:controller => "user_school_assignments", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/user_school_assignments/1").should == {:controller => "user_school_assignments", :action => "destroy", :id => "1"}
    end
  end
end
