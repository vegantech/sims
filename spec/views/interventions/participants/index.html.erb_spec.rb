require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/intervention_participants/index.html.erb" do
  include InterventionParticipantsHelper
  
  before(:each) do
    assigns[:intervention_participants] = [
      stub_model(InterventionParticipant,
        :intervention => ,
        :user => ,
        :role => "1"
      ),
      stub_model(InterventionParticipant,
        :intervention => ,
        :user => ,
        :role => "1"
      )
    ]
  end

  it "should render list of intervention_participants" do
    render "/intervention_participants/index.html.erb"
    response.should have_tag("tr>td", , 2)
    response.should have_tag("tr>td", , 2)
    response.should have_tag("tr>td", "1", 2)
  end
end

