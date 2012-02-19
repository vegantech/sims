require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CicoSettingsController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "cico_settings", :action => "index").should == "/cico_settings"
    end
  
    it "maps #new" do
      route_for(:controller => "cico_settings", :action => "new").should == "/cico_settings/new"
    end
  
    it "maps #show" do
      route_for(:controller => "cico_settings", :action => "show", :id => "1").should == "/cico_settings/1"
    end
  
    it "maps #edit" do
      route_for(:controller => "cico_settings", :action => "edit", :id => "1").should == "/cico_settings/1/edit"
    end

  it "maps #create" do
    route_for(:controller => "cico_settings", :action => "create").should == {:path => "/cico_settings", :method => :post}
  end

  it "maps #update" do
    route_for(:controller => "cico_settings", :action => "update", :id => "1").should == {:path =>"/cico_settings/1", :method => :put}
  end
  
    it "maps #destroy" do
      route_for(:controller => "cico_settings", :action => "destroy", :id => "1").should == {:path =>"/cico_settings/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/cico_settings").should == {:controller => "cico_settings", :action => "index"}
    end
  
    it "generates params for #new" do
      params_from(:get, "/cico_settings/new").should == {:controller => "cico_settings", :action => "new"}
    end
  
    it "generates params for #create" do
      params_from(:post, "/cico_settings").should == {:controller => "cico_settings", :action => "create"}
    end
  
    it "generates params for #show" do
      params_from(:get, "/cico_settings/1").should == {:controller => "cico_settings", :action => "show", :id => "1"}
    end
  
    it "generates params for #edit" do
      params_from(:get, "/cico_settings/1/edit").should == {:controller => "cico_settings", :action => "edit", :id => "1"}
    end
  
    it "generates params for #update" do
      params_from(:put, "/cico_settings/1").should == {:controller => "cico_settings", :action => "update", :id => "1"}
    end
  
    it "generates params for #destroy" do
      params_from(:delete, "/cico_settings/1").should == {:controller => "cico_settings", :action => "destroy", :id => "1"}
    end
  end
end
