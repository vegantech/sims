require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/intervention_builder_goals/edit.html.erb" do
  include InterventionBuilder::GoalsHelper
  
  before(:each) do
    assigns[:goal] = @goal = stub_model(InterventionBuilder::Goal,
      :new_record? => false
    )
  end

  it "should render edit form" do
    render "/intervention_builder_goals/edit.html.erb"
    
    response.should have_tag("form[action=#{goal_path(@goal)}][method=post]") do
    end
  end
end


