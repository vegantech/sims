require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe InterventionBuilder::ProbesController do
  it_should_behave_like "an authenticated controller"

  #Delete this example and add some real ones
  it "should use InterventionBuilder::ProbesController" do
    controller.should be_an_instance_of(InterventionBuilder::ProbesController)
  end

end
