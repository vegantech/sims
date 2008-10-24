require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/checklist_builder/elements/destroy" do
  before(:each) do
    render 'checklist_builder/elements/destroy'
  end
  
  #Delete this example and add some real ones or delete this file
  it "should tell you where to find the file" do
    response.should have_tag('p', %r[Find me in app/views/checklist_builder/elements/destroy])
  end
end
