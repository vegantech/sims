require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/intervention_participants/edit.html.erb" do
  include InterventionParticipantsHelper
  
  before(:each) do
    assigns[:intervention_participant] = @intervention_participant = stub_model(InterventionParticipant,
      :new_record? => false,
      :intervention => ,
      :user => ,
      :role => "1"
    )
  end

  it "should render edit form" do
    render "/intervention_participants/edit.html.erb"
    
    response.should have_tag("form[action=#{intervention_participant_path(@intervention_participant)}][method=post]") do
      with_tag('input#intervention_participant_intervention[name=?]', "intervention_participant[intervention]")
      with_tag('input#intervention_participant_user[name=?]', "intervention_participant[user]")
      with_tag('input#intervention_participant_role[name=?]', "intervention_participant[role]")
    end
  end
end


