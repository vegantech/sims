require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/tiers/index.html.erb" do
  include TiersHelper
  
  before(:each) do
    assigns[:tiers] = [
      stub_model(Tier,
        :title => "value for title",
        :position => "1"
      ),
      stub_model(Tier,
        :title => "value for title",
        :position => "1"
      )
    ]
  end

  it "should render list of tiers" do
    render "/tiers/index.html.erb"
    response.should have_tag("tr>td", "value for title", 2)
    response.should have_tag("tr>td", "1", 2)
  end
end

