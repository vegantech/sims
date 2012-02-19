require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CicoSchoolDaysController do
  before do
    pending "These are all incomplete"
  end
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "cico_school_days", :action => "index").should == "/cico_school_days"
    end
  
    it "maps #new" do
      route_for(:controller => "cico_school_days", :action => "new").should == "/cico_school_days/new"
    end
  
    it "maps #show" do
      route_for(:controller => "cico_school_days", :action => "show", :id => "1").should == "/cico_school_days/1"
    end
  
    it "maps #edit" do
      route_for(:controller => "cico_school_days", :action => "edit", :id => "1").should == "/cico_school_days/1/edit"
    end

  it "maps #create" do
    route_for(:controller => "cico_school_days", :action => "create").should == {:path => "/cico_school_days", :method => :post}
  end

  it "maps #update" do
    route_for(:controller => "cico_school_days", :action => "update", :id => "1").should == {:path =>"/cico_school_days/1", :method => :put}
  end
  
    it "maps #destroy" do
      route_for(:controller => "cico_school_days", :action => "destroy", :id => "1").should == {:path =>"/cico_school_days/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/cico_school_days").should == {:controller => "cico_school_days", :action => "index"}
    end
  
    it "generates params for #new" do
      params_from(:get, "/cico_school_days/new").should == {:controller => "cico_school_days", :action => "new"}
    end
  
    it "generates params for #create" do
      params_from(:post, "/cico_school_days").should == {:controller => "cico_school_days", :action => "create"}
    end
  
    it "generates params for #show" do
      params_from(:get, "/cico_school_days/1").should == {:controller => "cico_school_days", :action => "show", :id => "1"}
    end
  
    it "generates params for #edit" do
      params_from(:get, "/cico_school_days/1/edit").should == {:controller => "cico_school_days", :action => "edit", :id => "1"}
    end
  
    it "generates params for #update" do
      params_from(:put, "/cico_school_days/1").should == {:controller => "cico_school_days", :action => "update", :id => "1"}
    end
  
    it "generates params for #destroy" do
      params_from(:delete, "/cico_school_days/1").should == {:controller => "cico_school_days", :action => "destroy", :id => "1"}
    end
  end
end
