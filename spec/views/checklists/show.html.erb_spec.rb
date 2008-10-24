require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/checklists/show.html.erb" do
  include ChecklistsHelper
  
  before(:each) do
    assigns[:checklist] = @checklist = stub_model(Checklist)
  end

  it "should render attributes in <p>" do
    render "/checklists/show.html.erb"
  end
end

