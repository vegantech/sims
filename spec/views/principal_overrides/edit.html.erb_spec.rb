require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/principal_overrides/edit.html.erb" do
  include PrincipalOverridesHelper
  
  before(:each) do
    assigns[:principal_override] = @principal_override = stub_model(PrincipalOverride,
      :new_record? => false,
      :teacher => ,
      :student => ,
      :principal => ,
      :status => "1",
      :start_tier => ,
      :end_tier => ,
      :fufillment_reason => "value for fufillment_reason"
    )
  end

  it "should render edit form" do
    render "/principal_overrides/edit.html.erb"
    
    response.should have_tag("form[action=#{principal_override_path(@principal_override)}][method=post]") do
      with_tag('input#principal_override_teacher[name=?]', "principal_override[teacher]")
      with_tag('input#principal_override_student[name=?]', "principal_override[student]")
      with_tag('input#principal_override_principal[name=?]', "principal_override[principal]")
      with_tag('input#principal_override_status[name=?]', "principal_override[status]")
      with_tag('input#principal_override_start_tier[name=?]', "principal_override[start_tier]")
      with_tag('input#principal_override_end_tier[name=?]', "principal_override[end_tier]")
      with_tag('input#principal_override_fufillment_reason[name=?]', "principal_override[fufillment_reason]")
    end
  end
end


