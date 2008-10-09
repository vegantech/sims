require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/student_comments/index.html.erb" do
  include StudentCommentsHelper
  
  before(:each) do
    assigns[:student_comments] = [
      stub_model(StudentComment,
        :student => ,
        :user => ,
        :body => "value for body"
      ),
      stub_model(StudentComment,
        :student => ,
        :user => ,
        :body => "value for body"
      )
    ]
  end

  it "should render list of student_comments" do
    render "/student_comments/index.html.erb"
    response.should have_tag("tr>td", , 2)
    response.should have_tag("tr>td", , 2)
    response.should have_tag("tr>td", "value for body", 2)
  end
end

