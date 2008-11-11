require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/principal_overrides/show.html.erb" do
  include PrincipalOverridesHelper
  
  before(:each) do
    assigns[:principal_override] = @principal_override = stub_model(PrincipalOverride,
      :teacher => ,
      :student => ,
      :principal => ,
      :status => "1",
      :start_tier => ,
      :end_tier => ,
      :fufillment_reason => "value for fufillment_reason"
    )
  end

  it "should render attributes in <p>" do
    render "/principal_overrides/show.html.erb"
    response.should have_text(//)
    response.should have_text(//)
    response.should have_text(//)
    response.should have_text(/1/)
    response.should have_text(//)
    response.should have_text(//)
    response.should have_text(/value\ for\ fufillment_reason/)
  end
end

