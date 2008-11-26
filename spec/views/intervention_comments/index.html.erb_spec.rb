require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/intervention_comments/index.html.erb" do
  include InterventionCommentsHelper
  
  before(:each) do
    assigns[:intervention_comments] = [
      stub_model(InterventionComment,
        :intervention => ,
        :comment => "value for comment",
        :user => 
      ),
      stub_model(InterventionComment,
        :intervention => ,
        :comment => "value for comment",
        :user => 
      )
    ]
  end

  it "should render list of intervention_comments" do
    render "/intervention_comments/index.html.erb"
    response.should have_tag("tr>td", , 2)
    response.should have_tag("tr>td", "value for comment", 2)
    response.should have_tag("tr>td", , 2)
  end
end

