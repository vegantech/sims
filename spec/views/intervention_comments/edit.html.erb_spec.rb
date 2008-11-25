require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/intervention_comments/edit.html.erb" do
  include InterventionCommentsHelper
  
  before(:each) do
    assigns[:intervention_comment] = @intervention_comment = stub_model(InterventionComment,
      :new_record? => false,
      :intervention => ,
      :comment => "value for comment",
      :user => 
    )
  end

  it "should render edit form" do
    render "/intervention_comments/edit.html.erb"
    
    response.should have_tag("form[action=#{intervention_comment_path(@intervention_comment)}][method=post]") do
      with_tag('input#intervention_comment_intervention[name=?]', "intervention_comment[intervention]")
      with_tag('textarea#intervention_comment_comment[name=?]', "intervention_comment[comment]")
      with_tag('input#intervention_comment_user[name=?]', "intervention_comment[user]")
    end
  end
end


