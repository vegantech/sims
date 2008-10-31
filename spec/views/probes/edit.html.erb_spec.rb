require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/probes/edit.html.erb" do
  include ProbesHelper
  
  before(:each) do
    assigns[:probe] = @probe = stub_model(Probe,
      :new_record? => false,
      :score => "1",
      :assessment_type => "value for assessment_type",
      :district => ,
      :intervention_probe_assignmnet => 
    )
  end

  it "should render edit form" do
    render "/probes/edit.html.erb"
    
    response.should have_tag("form[action=#{probe_path(@probe)}][method=post]") do
      with_tag('input#probe_score[name=?]', "probe[score]")
      with_tag('input#probe_assessment_type[name=?]', "probe[assessment_type]")
      with_tag('input#probe_district[name=?]', "probe[district]")
      with_tag('input#probe_intervention_probe_assignmnet[name=?]', "probe[intervention_probe_assignmnet]")
    end
  end
end


