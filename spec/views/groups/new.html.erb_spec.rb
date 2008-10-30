require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/groups/new.html.erb" do
  include GroupsHelper
  
  before(:each) do
    assigns[:group] = stub_model(Group,
      :new_record? => true,
      :title => "value for title",
      :school => 
    )
  end

  it "should render new form" do
    render "/groups/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", groups_path) do
      with_tag("input#group_title[name=?]", "group[title]")
      with_tag("input#group_school[name=?]", "group[school]")
    end
  end
end


