require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/groups/edit.html.erb" do
  include GroupsHelper
  
  before(:each) do
    assigns[:group] = @group = stub_model(Group,
      :new_record? => false,
      :title => "value for title",
      :school => 
    )
  end

  it "should render edit form" do
    render "/groups/edit.html.erb"
    
    response.should have_tag("form[action=#{group_path(@group)}][method=post]") do
      with_tag('input#group_title[name=?]', "group[title]")
      with_tag('input#group_school[name=?]', "group[school]")
    end
  end
end


