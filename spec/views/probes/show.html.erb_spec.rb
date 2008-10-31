require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/probes/show.html.erb" do
  include ProbesHelper
  
  before(:each) do
    assigns[:probe] = @probe = stub_model(Probe,
      :score => "1",
      :assessment_type => "value for assessment_type",
      :district => ,
      :intervention_probe_assignmnet => 
    )
  end

  it "should render attributes in <p>" do
    render "/probes/show.html.erb"
    response.should have_text(/1/)
    response.should have_text(/value\ for\ assessment_type/)
    response.should have_text(//)
    response.should have_text(//)
  end
end

