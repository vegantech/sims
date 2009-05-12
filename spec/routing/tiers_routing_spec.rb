require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TiersController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "tiers", :action => "index").should == "/tiers"
    end
  
    it "maps #new" do
      route_for(:controller => "tiers", :action => "new").should == "/tiers/new"
    end
  
    it "maps #show" do
      route_for(:controller => "tiers", :action => "show", :id => "1").should == "/tiers/1"
    end
  
    it "maps #edit" do
      route_for(:controller => "tiers", :action => "edit", :id => "1").should == "/tiers/1/edit"
    end

  it "maps #create" do
    route_for(:controller => "tiers", :action => "create").should == {:path => "/tiers", :method => :post}
  end

  it "maps #update" do
    route_for(:controller => "tiers", :action => "update", :id => "1").should == {:path =>"/tiers/1", :method => :put}
  end
  
    it "maps #destroy" do
      route_for(:controller => "tiers", :action => "destroy", :id => "1").should == {:path =>"/tiers/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/tiers").should == {:controller => "tiers", :action => "index"}
    end
  
    it "generates params for #new" do
      params_from(:get, "/tiers/new").should == {:controller => "tiers", :action => "new"}
    end
  
    it "generates params for #create" do
      params_from(:post, "/tiers").should == {:controller => "tiers", :action => "create"}
    end
  
    it "generates params for #show" do
      params_from(:get, "/tiers/1").should == {:controller => "tiers", :action => "show", :id => "1"}
    end
  
    it "generates params for #edit" do
      params_from(:get, "/tiers/1/edit").should == {:controller => "tiers", :action => "edit", :id => "1"}
    end
  
    it "generates params for #update" do
      params_from(:put, "/tiers/1").should == {:controller => "tiers", :action => "update", :id => "1"}
    end
  
    it "generates params for #destroy" do
      params_from(:delete, "/tiers/1").should == {:controller => "tiers", :action => "destroy", :id => "1"}
    end
  end
end
