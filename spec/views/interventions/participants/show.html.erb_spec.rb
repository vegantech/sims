require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/intervention_participants/show.html.erb" do
  include InterventionParticipantsHelper
  
  before(:each) do
    assigns[:intervention_participant] = @intervention_participant = stub_model(InterventionParticipant,
      :intervention => ,
      :user => ,
      :role => "1"
    )
  end

  it "should render attributes in <p>" do
    render "/intervention_participants/show.html.erb"
    response.should have_text(//)
    response.should have_text(//)
    response.should have_text(/1/)
  end
end

