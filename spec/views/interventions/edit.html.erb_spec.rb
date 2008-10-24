require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/interventions/edit.html.erb" do
  include InterventionsHelper
  
  before(:each) do
    assigns[:intervention] = @intervention = stub_model(Intervention,
      :new_record? => false,
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

  it "should render edit form" do
    render "/interventions/edit.html.erb"
    
    response.should have_tag("form[action=#{intervention_path(@intervention)}][method=post]") do
      with_tag('input#intervention_user[name=?]', "intervention[user]")
      with_tag('input#intervention_student[name=?]', "intervention[student]")
      with_tag('input#intervention_intervention_definition[name=?]', "intervention[intervention_definition]")
      with_tag('input#intervention_frequency[name=?]', "intervention[frequency]")
      with_tag('input#intervention_frequency_multiplier[name=?]', "intervention[frequency_multiplier]")
      with_tag('input#intervention_time_length[name=?]', "intervention[time_length]")
      with_tag('input#intervention_time_length_number[name=?]', "intervention[time_length_number]")
      with_tag('input#intervention_active[name=?]', "intervention[active]")
      with_tag('input#intervention_ended_by[name=?]', "intervention[ended_by]")
      with_tag('input#intervention_district[name=?]', "intervention[district]")
    end
  end
end


