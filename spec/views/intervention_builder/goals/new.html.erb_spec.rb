require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/intervention_builder_goals/new.html.erb" do
  include InterventionBuilder::GoalsHelper
  
  before(:each) do
    assigns[:goal] = stub_model(InterventionBuilder::Goal,
      :new_record? => true
    )
  end

  it "should render new form" do
    render "/intervention_builder_goals/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", intervention_builder_goals_path) do
    end
  end
end


