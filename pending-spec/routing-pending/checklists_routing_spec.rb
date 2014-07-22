require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ChecklistsController do
  describe "route generation" do
    it "should map #index" do
      route_for(controller: "checklists", action: "index").should == "/checklists"
    end
  
    it "should map #new" do
      route_for(controller: "checklists", action: "new").should == "/checklists/new"
    end
  
    it "should map #show" do
      route_for(controller: "checklists", action: "show", id: "1").should == "/checklists/1"
    end
  
    it "should map #edit" do
      route_for(controller: "checklists", action: "edit", id: "1").should == "/checklists/1/edit"
    end
  
    it "should map #update" do
      route_for(controller: "checklists", action: "update", id: "1").should == {path: "/checklists/1", method: :put}
    end
  
    it "should map #destroy" do
      route_for(controller: "checklists", action: "destroy", id: "1").should == {path: "/checklists/1", method: :delete}
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/checklists").should == {controller: "checklists", action: "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/checklists/new").should == {controller: "checklists", action: "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/checklists").should == {controller: "checklists", action: "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/checklists/1").should == {controller: "checklists", action: "show", id: "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/checklists/1/edit").should == {controller: "checklists", action: "edit", id: "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/checklists/1").should == {controller: "checklists", action: "update", id: "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/checklists/1").should == {controller: "checklists", action: "destroy", id: "1"}
    end
  end
end
