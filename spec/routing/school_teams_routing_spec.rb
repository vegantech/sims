require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SchoolTeamsController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "school_teams", :action => "index").should == "/school_teams"
    end
  
    it "maps #new" do
      route_for(:controller => "school_teams", :action => "new").should == "/school_teams/new"
    end
  
    it "maps #show" do
      route_for(:controller => "school_teams", :action => "show", :id => "1").should == "/school_teams/1"
    end
  
    it "maps #edit" do
      route_for(:controller => "school_teams", :action => "edit", :id => "1").should == "/school_teams/1/edit"
    end

  it "maps #create" do
    route_for(:controller => "school_teams", :action => "create").should == {:path => "/school_teams", :method => :post}
  end

  it "maps #update" do
    route_for(:controller => "school_teams", :action => "update", :id => "1").should == {:path =>"/school_teams/1", :method => :put}
  end
  
    it "maps #destroy" do
      route_for(:controller => "school_teams", :action => "destroy", :id => "1").should == {:path =>"/school_teams/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/school_teams").should == {:controller => "school_teams", :action => "index"}
    end
  
    it "generates params for #new" do
      params_from(:get, "/school_teams/new").should == {:controller => "school_teams", :action => "new"}
    end
  
    it "generates params for #create" do
      params_from(:post, "/school_teams").should == {:controller => "school_teams", :action => "create"}
    end
  
    it "generates params for #show" do
      params_from(:get, "/school_teams/1").should == {:controller => "school_teams", :action => "show", :id => "1"}
    end
  
    it "generates params for #edit" do
      params_from(:get, "/school_teams/1/edit").should == {:controller => "school_teams", :action => "edit", :id => "1"}
    end
  
    it "generates params for #update" do
      params_from(:put, "/school_teams/1").should == {:controller => "school_teams", :action => "update", :id => "1"}
    end
  
    it "generates params for #destroy" do
      params_from(:delete, "/school_teams/1").should == {:controller => "school_teams", :action => "destroy", :id => "1"}
    end
  end
end
