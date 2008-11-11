require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe InterventionBuilder::CategoriesController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"

  #Delete this example and add some real ones
  it "should use InterventionBuilder::CategoriesController" do
    controller.should be_an_instance_of(InterventionBuilder::CategoriesController)
  end

end
