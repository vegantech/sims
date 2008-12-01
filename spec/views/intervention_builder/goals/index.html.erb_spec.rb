require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/intervention_builder_goals/index.html.erb" do
  include InterventionBuilder::GoalsHelper
  
  before(:each) do
    assigns[:intervention_builder_goals] = [
      stub_model(InterventionBuilder::Goal),
      stub_model(InterventionBuilder::Goal)
    ]
  end

  it "should render list of intervention_builder_goals" do
    render "/intervention_builder_goals/index.html.erb"
  end
end

