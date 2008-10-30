require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/groups/index.html.erb" do
  include GroupsHelper
  
  before(:each) do
    assigns[:groups] = [
      stub_model(Group,
        :title => "value for title",
        :school => 
      ),
      stub_model(Group,
        :title => "value for title",
        :school => 
      )
    ]
  end

  it "should render list of groups" do
    render "/groups/index.html.erb"
    response.should have_tag("tr>td", "value for title", 2)
    response.should have_tag("tr>td", , 2)
  end
end

