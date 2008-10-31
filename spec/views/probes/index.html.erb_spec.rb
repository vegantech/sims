require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/probes/index.html.erb" do
  include ProbesHelper
  
  before(:each) do
    assigns[:probes] = [
      stub_model(Probe,
        :score => "1",
        :assessment_type => "value for assessment_type",
        :district => ,
        :intervention_probe_assignmnet => 
      ),
      stub_model(Probe,
        :score => "1",
        :assessment_type => "value for assessment_type",
        :district => ,
        :intervention_probe_assignmnet => 
      )
    ]
  end

  it "should render list of probes" do
    render "/probes/index.html.erb"
    response.should have_tag("tr>td", "1", 2)
    response.should have_tag("tr>td", "value for assessment_type", 2)
    response.should have_tag("tr>td", , 2)
    response.should have_tag("tr>td", , 2)
  end
end

