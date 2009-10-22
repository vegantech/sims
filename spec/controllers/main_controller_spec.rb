require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MainController do
  
  describe "responding to GET index" do

    it "should redorect to login if the district no longer exists" do
      controller.should_receive(:dropdowns)
      controller.stub!(:current_user_id => 123)
      controller.stub!(:current_district => nil)
      controller.should_not_receive(:authenticate)
      get :index
      response.should be_redirect
    end

    it "should be successful and not call the before filter" do
      controller.should_receive(:dropdowns)
      controller.stub!(:current_user_id => nil)
      controller.should_not_receive(:authenticate)
      get :index
      response.should be_success
    end
 
  end
end
