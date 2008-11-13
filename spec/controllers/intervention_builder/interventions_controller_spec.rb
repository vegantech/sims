require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe InterventionBuilder::InterventionsController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"

  #Delete this example and add some real ones
  it "should use InterventionBuilder::InterventionsController" do
    controller.should be_an_instance_of(InterventionBuilder::InterventionsController)
  end

end
