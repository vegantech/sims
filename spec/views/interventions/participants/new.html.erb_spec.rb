require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/intervention_participants/new.html.erb" do
  include InterventionParticipantsHelper
  
  before(:each) do
    assigns[:intervention_participant] = stub_model(InterventionParticipant,
      :new_record? => true,
      :intervention => ,
      :user => ,
      :role => "1"
    )
  end

  it "should render new form" do
    render "/intervention_participants/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", intervention_participants_path) do
      with_tag("input#intervention_participant_intervention[name=?]", "intervention_participant[intervention]")
      with_tag("input#intervention_participant_user[name=?]", "intervention_participant[user]")
      with_tag("input#intervention_participant_role[name=?]", "intervention_participant[role]")
    end
  end
end


