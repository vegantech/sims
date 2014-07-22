require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ConsultationFormsController do
  describe "route generation" do
    it "maps #index" do
      route_for(controller: "consultation_forms", action: "index").should == "/consultation_forms"
    end
  
    it "maps #new" do
      route_for(controller: "consultation_forms", action: "new").should == "/consultation_forms/new"
    end
  
    it "maps #show" do
      route_for(controller: "consultation_forms", action: "show", id: "1").should == "/consultation_forms/1"
    end
  
    it "maps #edit" do
      route_for(controller: "consultation_forms", action: "edit", id: "1").should == "/consultation_forms/1/edit"
    end

  it "maps #create" do
    route_for(controller: "consultation_forms", action: "create").should == {path: "/consultation_forms", method: :post}
  end

  it "maps #update" do
    route_for(controller: "consultation_forms", action: "update", id: "1").should == {path: "/consultation_forms/1", method: :put}
  end
  
    it "maps #destroy" do
      route_for(controller: "consultation_forms", action: "destroy", id: "1").should == {path: "/consultation_forms/1", method: :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/consultation_forms").should == {controller: "consultation_forms", action: "index"}
    end
  
    it "generates params for #new" do
      params_from(:get, "/consultation_forms/new").should == {controller: "consultation_forms", action: "new"}
    end
  
    it "generates params for #create" do
      params_from(:post, "/consultation_forms").should == {controller: "consultation_forms", action: "create"}
    end
  
    it "generates params for #show" do
      params_from(:get, "/consultation_forms/1").should == {controller: "consultation_forms", action: "show", id: "1"}
    end
  
    it "generates params for #edit" do
      params_from(:get, "/consultation_forms/1/edit").should == {controller: "consultation_forms", action: "edit", id: "1"}
    end
  
    it "generates params for #update" do
      params_from(:put, "/consultation_forms/1").should == {controller: "consultation_forms", action: "update", id: "1"}
    end
  
    it "generates params for #destroy" do
      params_from(:delete, "/consultation_forms/1").should == {controller: "consultation_forms", action: "destroy", id: "1"}
    end
  end
end
