require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/tiers/show.html.erb" do
  include TiersHelper
  
  before(:each) do
    assigns[:tier] = @tier = stub_model(Tier,
      :title => "value for title",
      :position => "1"
    )
  end

  it "should render attributes in <p>" do
    render "/tiers/show.html.erb"
    response.should have_text(/value\ for\ title/)
    response.should have_text(/1/)
  end
end

