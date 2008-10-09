require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/student_comments/new.html.erb" do
  include StudentCommentsHelper
  
  before(:each) do
    assigns[:student_comment] = stub_model(StudentComment,
      :new_record? => true,
      :student => ,
      :user => ,
      :body => "value for body"
    )
  end

  it "should render new form" do
    render "/student_comments/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", student_comments_path) do
      with_tag("input#student_comment_student[name=?]", "student_comment[student]")
      with_tag("input#student_comment_user[name=?]", "student_comment[user]")
      with_tag("textarea#student_comment_body[name=?]", "student_comment[body]")
    end
  end
end


