require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/roles/show.html.erb" do
  include RolesHelper
  
  before(:each) do
    assigns[:role] = @role = stub_model(Role,
      :name => "value for name",
      :district => ,
      :state => ,
      :country => ,
      :system => false,
      :position => "1"
    )
  end

  it "should render attributes in <p>" do
    render "/roles/show.html.erb"
    response.should have_text(/value\ for\ name/)
    response.should have_text(//)
    response.should have_text(//)
    response.should have_text(//)
    response.should have_text(/als/)
    response.should have_text(/1/)
  end
end

