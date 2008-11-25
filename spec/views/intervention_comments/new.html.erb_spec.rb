require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/intervention_comments/new.html.erb" do
  include InterventionCommentsHelper
  
  before(:each) do
    assigns[:intervention_comment] = stub_model(InterventionComment,
      :new_record? => true,
      :intervention => ,
      :comment => "value for comment",
      :user => 
    )
  end

  it "should render new form" do
    render "/intervention_comments/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", intervention_comments_path) do
      with_tag("input#intervention_comment_intervention[name=?]", "intervention_comment[intervention]")
      with_tag("textarea#intervention_comment_comment[name=?]", "intervention_comment[comment]")
      with_tag("input#intervention_comment_user[name=?]", "intervention_comment[user]")
    end
  end
end


