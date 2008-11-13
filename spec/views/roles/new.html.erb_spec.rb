require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/roles/new.html.erb" do
  include RolesHelper
  
  before(:each) do
    assigns[:role] = stub_model(Role,
      :new_record? => true,
      :name => "value for name",
      :district => ,
      :state => ,
      :country => ,
      :system => false,
      :position => "1"
    )
  end

  it "should render new form" do
    render "/roles/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", roles_path) do
      with_tag("input#role_name[name=?]", "role[name]")
      with_tag("input#role_district[name=?]", "role[district]")
      with_tag("input#role_state[name=?]", "role[state]")
      with_tag("input#role_country[name=?]", "role[country]")
      with_tag("input#role_system[name=?]", "role[system]")
      with_tag("input#role_position[name=?]", "role[position]")
    end
  end
end


