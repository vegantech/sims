require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProbeQuestionsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "probe_questions", :action => "index").should == "/probe_questions"
    end
  
    it "should map #new" do
      route_for(:controller => "probe_questions", :action => "new").should == "/probe_questions/new"
    end
  
    it "should map #show" do
      route_for(:controller => "probe_questions", :action => "show", :id => 1).should == "/probe_questions/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "probe_questions", :action => "edit", :id => 1).should == "/probe_questions/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "probe_questions", :action => "update", :id => 1).should == "/probe_questions/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "probe_questions", :action => "destroy", :id => 1).should == "/probe_questions/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/probe_questions").should == {:controller => "probe_questions", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/probe_questions/new").should == {:controller => "probe_questions", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/probe_questions").should == {:controller => "probe_questions", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/probe_questions/1").should == {:controller => "probe_questions", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/probe_questions/1/edit").should == {:controller => "probe_questions", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/probe_questions/1").should == {:controller => "probe_questions", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/probe_questions/1").should == {:controller => "probe_questions", :action => "destroy", :id => "1"}
    end
  end
end
