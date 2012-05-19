require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe QuicklistItemsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "quicklist_items", :action => "index").should == "/quicklist_items"
    end
  
    it "should map #new" do
      route_for(:controller => "quicklist_items", :action => "new").should == "/quicklist_items/new"
    end
  
    it "should map #show" do
      route_for(:controller => "quicklist_items", :action => "show", :id => "1").should == "/quicklist_items/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "quicklist_items", :action => "edit", :id => "1").should == "/quicklist_items/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "quicklist_items", :action => "update", :id => "1").should == {:path => "/quicklist_items/1", :method => :put}
    end
  
    it "should map #destroy" do
      route_for(:controller => "quicklist_items", :action => "destroy", :id => "1").should == {:path => "/quicklist_items/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/quicklist_items").should == {:controller => "quicklist_items", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/quicklist_items/new").should == {:controller => "quicklist_items", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/quicklist_items").should == {:controller => "quicklist_items", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/quicklist_items/1").should == {:controller => "quicklist_items", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/quicklist_items/1/edit").should == {:controller => "quicklist_items", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/quicklist_items/1").should == {:controller => "quicklist_items", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/quicklist_items/1").should == {:controller => "quicklist_items", :action => "destroy", :id => "1"}
    end
  end
end
