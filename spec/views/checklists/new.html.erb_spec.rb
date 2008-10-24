require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/checklists/new.html.erb" do
  include ChecklistsHelper
  
  before(:each) do
    assigns[:checklist] = stub_model(Checklist,
      :new_record? => true
    )
  end

  it "should render new form" do
    render "/checklists/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", checklists_path) do
    end
  end
end


