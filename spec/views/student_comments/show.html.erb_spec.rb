require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/student_comments/show.html.erb" do
  include StudentCommentsHelper
  
  before(:each) do
    assigns[:student_comment] = @student_comment = stub_model(StudentComment,
      :student => ,
      :user => ,
      :body => "value for body"
    )
  end

  it "should render attributes in <p>" do
    render "/student_comments/show.html.erb"
    response.should have_text(//)
    response.should have_text(//)
    response.should have_text(/value\ for\ body/)
  end
end

