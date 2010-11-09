require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UnattachedInterventionsController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"

  before do
    controller.stub!(:current_user=>current_user)
  end


  def current_user
    @current_user ||= mock_user
  end

  
  describe "GET index" do
   end


  describe "GET edit" do
 end

  describe "PUT udpate" do
  end

end
