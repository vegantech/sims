require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FlagDescriptionsController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "flag_descriptions", :action => "index").should == "/flag_descriptions"
    end
  
    it "maps #new" do
      route_for(:controller => "flag_descriptions", :action => "new").should == "/flag_descriptions/new"
    end
  
    it "maps #show" do
      route_for(:controller => "flag_descriptions", :action => "show", :id => "1").should == "/flag_descriptions/1"
    end
  
    it "maps #edit" do
      route_for(:controller => "flag_descriptions", :action => "edit", :id => "1").should == "/flag_descriptions/1/edit"
    end

  it "maps #create" do
    route_for(:controller => "flag_descriptions", :action => "create").should == {:path => "/flag_descriptions", :method => :post}
  end

  it "maps #update" do
    route_for(:controller => "flag_descriptions", :action => "update", :id => "1").should == {:path =>"/flag_descriptions/1", :method => :put}
  end
  
    it "maps #destroy" do
      route_for(:controller => "flag_descriptions", :action => "destroy", :id => "1").should == {:path =>"/flag_descriptions/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/flag_descriptions").should == {:controller => "flag_descriptions", :action => "index"}
    end
  
    it "generates params for #new" do
      params_from(:get, "/flag_descriptions/new").should == {:controller => "flag_descriptions", :action => "new"}
    end
  
    it "generates params for #create" do
      params_from(:post, "/flag_descriptions").should == {:controller => "flag_descriptions", :action => "create"}
    end
  
    it "generates params for #show" do
      params_from(:get, "/flag_descriptions/1").should == {:controller => "flag_descriptions", :action => "show", :id => "1"}
    end
  
    it "generates params for #edit" do
      params_from(:get, "/flag_descriptions/1/edit").should == {:controller => "flag_descriptions", :action => "edit", :id => "1"}
    end
  
    it "generates params for #update" do
      params_from(:put, "/flag_descriptions/1").should == {:controller => "flag_descriptions", :action => "update", :id => "1"}
    end
  
    it "generates params for #destroy" do
      params_from(:delete, "/flag_descriptions/1").should == {:controller => "flag_descriptions", :action => "destroy", :id => "1"}
    end
  end
end
