require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/groups/show.html.erb" do
  include GroupsHelper
  
  before(:each) do
    assigns[:group] = @group = stub_model(Group,
      :title => "value for title",
      :school => 
    )
  end

  it "should render attributes in <p>" do
    render "/groups/show.html.erb"
    response.should have_text(/value\ for\ title/)
    response.should have_text(//)
  end
end

