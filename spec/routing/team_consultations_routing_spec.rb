require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TeamConsultationsController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "team_consultations", :action => "index").should == "/team_consultations"
    end
  
    it "maps #new" do
      route_for(:controller => "team_consultations", :action => "new").should == "/team_consultations/new"
    end
  
    it "maps #show" do
      route_for(:controller => "team_consultations", :action => "show", :id => "1").should == "/team_consultations/1"
    end
  
    it "maps #edit" do
      route_for(:controller => "team_consultations", :action => "edit", :id => "1").should == "/team_consultations/1/edit"
    end

  it "maps #create" do
    route_for(:controller => "team_consultations", :action => "create").should == {:path => "/team_consultations", :method => :post}
  end

  it "maps #update" do
    route_for(:controller => "team_consultations", :action => "update", :id => "1").should == {:path =>"/team_consultations/1", :method => :put}
  end
  
    it "maps #destroy" do
      route_for(:controller => "team_consultations", :action => "destroy", :id => "1").should == {:path =>"/team_consultations/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/team_consultations").should == {:controller => "team_consultations", :action => "index"}
    end
  
    it "generates params for #new" do
      params_from(:get, "/team_consultations/new").should == {:controller => "team_consultations", :action => "new"}
    end
  
    it "generates params for #create" do
      params_from(:post, "/team_consultations").should == {:controller => "team_consultations", :action => "create"}
    end
  
    it "generates params for #show" do
      params_from(:get, "/team_consultations/1").should == {:controller => "team_consultations", :action => "show", :id => "1"}
    end
  
    it "generates params for #edit" do
      params_from(:get, "/team_consultations/1/edit").should == {:controller => "team_consultations", :action => "edit", :id => "1"}
    end
  
    it "generates params for #update" do
      params_from(:put, "/team_consultations/1").should == {:controller => "team_consultations", :action => "update", :id => "1"}
    end
  
    it "generates params for #destroy" do
      params_from(:delete, "/team_consultations/1").should == {:controller => "team_consultations", :action => "destroy", :id => "1"}
    end
  end
end
