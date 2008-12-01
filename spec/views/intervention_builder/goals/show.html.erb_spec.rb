require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/intervention_builder_goals/show.html.erb" do
  include InterventionBuilder::GoalsHelper
  
  before(:each) do
    assigns[:goal] = @goal = stub_model(InterventionBuilder::Goal)
  end

  it "should render attributes in <p>" do
    render "/intervention_builder_goals/show.html.erb"
  end
end

