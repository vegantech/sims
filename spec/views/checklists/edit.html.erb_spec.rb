require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/checklists/edit.html.erb" do
  include ChecklistsHelper
  
  before(:each) do
    assigns[:checklist] = @checklist = stub_model(Checklist,
      :new_record? => false
    )
  end

  it "should render edit form" do
    render "/checklists/edit.html.erb"
    
    response.should have_tag("form[action=#{checklist_path(@checklist)}][method=post]") do
    end
  end
end


