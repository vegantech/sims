require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/roles/index.html.erb" do
  include RolesHelper
  
  before(:each) do
    assigns[:roles] = [
      stub_model(Role,
        :name => "value for name",
        :district => ,
        :state => ,
        :country => ,
        :system => false,
        :position => "1"
      ),
      stub_model(Role,
        :name => "value for name",
        :district => ,
        :state => ,
        :country => ,
        :system => false,
        :position => "1"
      )
    ]
  end

  it "should render list of roles" do
    render "/roles/index.html.erb"
    response.should have_tag("tr>td", "value for name", 2)
    response.should have_tag("tr>td", , 2)
    response.should have_tag("tr>td", , 2)
    response.should have_tag("tr>td", , 2)
    response.should have_tag("tr>td", false, 2)
    response.should have_tag("tr>td", "1", 2)
  end
end

