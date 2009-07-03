require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TeamAgendasController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "team_agendas", :action => "index").should == "/team_agendas"
    end
  
    it "maps #new" do
      route_for(:controller => "team_agendas", :action => "new").should == "/team_agendas/new"
    end
  
    it "maps #show" do
      route_for(:controller => "team_agendas", :action => "show", :id => "1").should == "/team_agendas/1"
    end
  
    it "maps #edit" do
      route_for(:controller => "team_agendas", :action => "edit", :id => "1").should == "/team_agendas/1/edit"
    end

  it "maps #create" do
    route_for(:controller => "team_agendas", :action => "create").should == {:path => "/team_agendas", :method => :post}
  end

  it "maps #update" do
    route_for(:controller => "team_agendas", :action => "update", :id => "1").should == {:path =>"/team_agendas/1", :method => :put}
  end
  
    it "maps #destroy" do
      route_for(:controller => "team_agendas", :action => "destroy", :id => "1").should == {:path =>"/team_agendas/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/team_agendas").should == {:controller => "team_agendas", :action => "index"}
    end
  
    it "generates params for #new" do
      params_from(:get, "/team_agendas/new").should == {:controller => "team_agendas", :action => "new"}
    end
  
    it "generates params for #create" do
      params_from(:post, "/team_agendas").should == {:controller => "team_agendas", :action => "create"}
    end
  
    it "generates params for #show" do
      params_from(:get, "/team_agendas/1").should == {:controller => "team_agendas", :action => "show", :id => "1"}
    end
  
    it "generates params for #edit" do
      params_from(:get, "/team_agendas/1/edit").should == {:controller => "team_agendas", :action => "edit", :id => "1"}
    end
  
    it "generates params for #update" do
      params_from(:put, "/team_agendas/1").should == {:controller => "team_agendas", :action => "update", :id => "1"}
    end
  
    it "generates params for #destroy" do
      params_from(:delete, "/team_agendas/1").should == {:controller => "team_agendas", :action => "destroy", :id => "1"}
    end
  end
end
