require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/interventions/show.html.erb" do
  include InterventionsHelper
  
  before(:each) do
    assigns[:intervention] = @intervention = stub_model(Intervention,
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
  end

  it "should render attributes in <p>" do
    render "/interventions/show.html.erb"
    response.should have_text(//)
    response.should have_text(//)
    response.should have_text(//)
    response.should have_text(//)
    response.should have_text(/1/)
    response.should have_text(//)
    response.should have_text(/1/)
    response.should have_text(/als/)
    response.should have_text(//)
    response.should have_text(//)
  end
end

