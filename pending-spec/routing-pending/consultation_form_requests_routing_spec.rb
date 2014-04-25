require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ConsultationFormRequestsController do
  describe "route generation" do
    it "maps #index" do
      route_for(controller: "consultation_form_requests", action: "index").should == "/consultation_form_requests"
    end
  
    it "maps #new" do
      route_for(controller: "consultation_form_requests", action: "new").should == "/consultation_form_requests/new"
    end
  
    it "maps #show" do
      route_for(controller: "consultation_form_requests", action: "show", id: "1").should == "/consultation_form_requests/1"
    end
  
    it "maps #edit" do
      route_for(controller: "consultation_form_requests", action: "edit", id: "1").should == "/consultation_form_requests/1/edit"
    end

  it "maps #create" do
    route_for(controller: "consultation_form_requests", action: "create").should == {path: "/consultation_form_requests", method: :post}
  end

  it "maps #update" do
    route_for(controller: "consultation_form_requests", action: "update", id: "1").should == {path: "/consultation_form_requests/1", method: :put}
  end
  
    it "maps #destroy" do
      route_for(controller: "consultation_form_requests", action: "destroy", id: "1").should == {path: "/consultation_form_requests/1", method: :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/consultation_form_requests").should == {controller: "consultation_form_requests", action: "index"}
    end
  
    it "generates params for #new" do
      params_from(:get, "/consultation_form_requests/new").should == {controller: "consultation_form_requests", action: "new"}
    end
  
    it "generates params for #create" do
      params_from(:post, "/consultation_form_requests").should == {controller: "consultation_form_requests", action: "create"}
    end
  
    it "generates params for #show" do
      params_from(:get, "/consultation_form_requests/1").should == {controller: "consultation_form_requests", action: "show", id: "1"}
    end
  
    it "generates params for #edit" do
      params_from(:get, "/consultation_form_requests/1/edit").should == {controller: "consultation_form_requests", action: "edit", id: "1"}
    end
  
    it "generates params for #update" do
      params_from(:put, "/consultation_form_requests/1").should == {controller: "consultation_form_requests", action: "update", id: "1"}
    end
  
    it "generates params for #destroy" do
      params_from(:delete, "/consultation_form_requests/1").should == {controller: "consultation_form_requests", action: "destroy", id: "1"}
    end
  end
end
