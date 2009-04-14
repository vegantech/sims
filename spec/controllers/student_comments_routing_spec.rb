require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StudentCommentsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "student_comments", :action => "index").should == "/student_comments"
    end
  
    it "should map #new" do
      route_for(:controller => "student_comments", :action => "new").should == "/student_comments/new"
    end
  
    it "should map #show" do
      route_for(:controller => "student_comments", :action => "show", :id => "1").should == "/student_comments/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "student_comments", :action => "edit", :id => "1").should == "/student_comments/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "student_comments", :action => "update", :id => "1").should == "/student_comments/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "student_comments", :action => "destroy", :id => "1").should == "/student_comments/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/student_comments").should == {:controller => "student_comments", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/student_comments/new").should == {:controller => "student_comments", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/student_comments").should == {:controller => "student_comments", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/student_comments/1").should == {:controller => "student_comments", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/student_comments/1/edit").should == {:controller => "student_comments", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/student_comments/1").should == {:controller => "student_comments", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/student_comments/1").should == {:controller => "student_comments", :action => "destroy", :id => "1"}
    end
  end
end
