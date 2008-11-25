require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/intervention_comments/show.html.erb" do
  include InterventionCommentsHelper
  
  before(:each) do
    assigns[:intervention_comment] = @intervention_comment = stub_model(InterventionComment,
      :intervention => ,
      :comment => "value for comment",
      :user => 
    )
  end

  it "should render attributes in <p>" do
    render "/intervention_comments/show.html.erb"
    response.should have_text(//)
    response.should have_text(/value\ for\ comment/)
    response.should have_text(//)
  end
end

