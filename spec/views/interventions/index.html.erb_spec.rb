require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/interventions/index.html.erb" do
  include InterventionsHelper
  
  before(:each) do
    assigns[:interventions] = [
      stub_model(Intervention,
        :user => ,
        :student => ,
        :intervention_definition => ,
        :frequency => ,
        :frequency_multiplier => "1",
        :time_length => ,
        :time_length_number => "1",
        :active => false,
        :ended_by => ,
        :district => 
      ),
      stub_model(Intervention,
        :user => ,
        :student => ,
        :intervention_definition => ,
        :frequency => ,
        :frequency_multiplier => "1",
        :time_length => ,
        :time_length_number => "1",
        :active => false,
        :ended_by => ,
        :district => 
      )
    ]
  end

  it "should render list of interventions" do
    render "/interventions/index.html.erb"
    response.should have_tag("tr>td", , 2)
    response.should have_tag("tr>td", , 2)
    response.should have_tag("tr>td", , 2)
    response.should have_tag("tr>td", , 2)
    response.should have_tag("tr>td", "1", 2)
    response.should have_tag("tr>td", , 2)
    response.should have_tag("tr>td", "1", 2)
    response.should have_tag("tr>td", false, 2)
    response.should have_tag("tr>td", , 2)
    response.should have_tag("tr>td", , 2)
  end
end

