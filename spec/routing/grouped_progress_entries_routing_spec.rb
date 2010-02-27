require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GroupedProgressEntriesController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "grouped_progress_entries", :action => "index").should == "/grouped_progress_entries"
    end
  
    it "maps #new" do
      route_for(:controller => "grouped_progress_entries", :action => "new").should == "/grouped_progress_entries/new"
    end
  
    it "maps #show" do
      route_for(:controller => "grouped_progress_entries", :action => "show", :id => "1").should == "/grouped_progress_entries/1"
    end
  
    it "maps #edit" do
      route_for(:controller => "grouped_progress_entries", :action => "edit", :id => "1").should == "/grouped_progress_entries/1/edit"
    end

  it "maps #create" do
    route_for(:controller => "grouped_progress_entries", :action => "create").should == {:path => "/grouped_progress_entries", :method => :post}
  end

  it "maps #update" do
    route_for(:controller => "grouped_progress_entries", :action => "update", :id => "1").should == {:path =>"/grouped_progress_entries/1", :method => :put}
  end
  
    it "maps #destroy" do
      route_for(:controller => "grouped_progress_entries", :action => "destroy", :id => "1").should == {:path =>"/grouped_progress_entries/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/grouped_progress_entries").should == {:controller => "grouped_progress_entries", :action => "index"}
    end
  
    it "generates params for #new" do
      params_from(:get, "/grouped_progress_entries/new").should == {:controller => "grouped_progress_entries", :action => "new"}
    end
  
    it "generates params for #create" do
      params_from(:post, "/grouped_progress_entries").should == {:controller => "grouped_progress_entries", :action => "create"}
    end
  
    it "generates params for #show" do
      params_from(:get, "/grouped_progress_entries/1").should == {:controller => "grouped_progress_entries", :action => "show", :id => "1"}
    end
  
    it "generates params for #edit" do
      params_from(:get, "/grouped_progress_entries/1/edit").should == {:controller => "grouped_progress_entries", :action => "edit", :id => "1"}
    end
  
    it "generates params for #update" do
      params_from(:put, "/grouped_progress_entries/1").should == {:controller => "grouped_progress_entries", :action => "update", :id => "1"}
    end
  
    it "generates params for #destroy" do
      params_from(:delete, "/grouped_progress_entries/1").should == {:controller => "grouped_progress_entries", :action => "destroy", :id => "1"}
    end
  end
end
