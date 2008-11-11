require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/principal_overrides/index.html.erb" do
  include PrincipalOverridesHelper
  
  before(:each) do
    assigns[:principal_overrides] = [
      stub_model(PrincipalOverride,
        :teacher => ,
        :student => ,
        :principal => ,
        :status => "1",
        :start_tier => ,
        :end_tier => ,
        :fufillment_reason => "value for fufillment_reason"
      ),
      stub_model(PrincipalOverride,
        :teacher => ,
        :student => ,
        :principal => ,
        :status => "1",
        :start_tier => ,
        :end_tier => ,
        :fufillment_reason => "value for fufillment_reason"
      )
    ]
  end

  it "should render list of principal_overrides" do
    render "/principal_overrides/index.html.erb"
    response.should have_tag("tr>td", , 2)
    response.should have_tag("tr>td", , 2)
    response.should have_tag("tr>td", , 2)
    response.should have_tag("tr>td", "1", 2)
    response.should have_tag("tr>td", , 2)
    response.should have_tag("tr>td", , 2)
    response.should have_tag("tr>td", "value for fufillment_reason", 2)
  end
end

