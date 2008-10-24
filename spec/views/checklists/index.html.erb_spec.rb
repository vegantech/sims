require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/checklists/index.html.erb" do
  include ChecklistsHelper
  
  before(:each) do
    assigns[:checklists] = [
      stub_model(Checklist),
      stub_model(Checklist)
    ]
  end

  it "should render list of checklists" do
    render "/checklists/index.html.erb"
  end
end

