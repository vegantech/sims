require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CustomFlagsController do
  describe "route generation" do
    it "should map #index" do
      route_for(controller: "custom_flags", action: "index").should == "/custom_flags"
    end
  
    it "should map #new" do
      route_for(controller: "custom_flags", action: "new").should == "/custom_flags/new"
    end
  
    it "should map #show" do
      route_for(controller: "custom_flags", action: "show", id: "1").should == "/custom_flags/1"
    end
  
    it "should map #edit" do
      route_for(controller: "custom_flags", action: "edit", id: "1").should == "/custom_flags/1/edit"
    end
  
    it "should map #update" do
      route_for(controller: "custom_flags", action: "update", id: "1").should == {path: "/custom_flags/1", method: :put}
    end
  
    it "should map #destroy" do
      route_for(controller: "custom_flags", action: "destroy", id: "1").should == {path: "/custom_flags/delete/1", method: :delete}
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/custom_flags").should == {controller: "custom_flags", action: "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/custom_flags/new").should == {controller: "custom_flags", action: "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/custom_flags").should == {controller: "custom_flags", action: "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/custom_flags/1").should == {controller: "custom_flags", action: "show", id: "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/custom_flags/1/edit").should == {controller: "custom_flags", action: "edit", id: "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/custom_flags/1").should == {controller: "custom_flags", action: "update", id: "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/custom_flags/1").should == {controller: "custom_flags", action: "destroy", id: "1"}
    end
  end
end
