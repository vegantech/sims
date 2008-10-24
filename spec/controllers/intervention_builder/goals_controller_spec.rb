require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe InterventionBuilder::GoalsController do
  it_should_behave_like "an authenticated controller"

  #Delete this example and add some real ones
  it "should use InterventionBuilder::GoalsController" do
    controller.should be_an_instance_of(InterventionBuilder::GoalsController)
  end

end
