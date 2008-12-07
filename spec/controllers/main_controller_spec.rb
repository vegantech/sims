require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MainController do
  
  describe "responding to GET index" do

    it "should be successful and not call the before filter" do
      controller.should_receive(:dropdowns)
      controller.should_not_receive(:authenticate)
      get :index
      response.should be_success
    end
  end
end
