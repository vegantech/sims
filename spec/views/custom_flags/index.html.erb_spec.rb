require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/custom_flags/index.html.erb" do
  include CustomFlagsHelper
  
  before(:each) do
    assigns[:custom_flags] = [
      stub_model(CustomFlag,
        :category => "value for category",
        :district => "value for district",
        :user => "value for user",
        :reason => "value for reason",
        :type => "value for type"
      ),
      stub_model(CustomFlag,
        :category => "value for category",
        :district => "value for district",
        :user => "value for user",
        :reason => "value for reason",
        :type => "value for type"
      )
    ]
  end

  it "should render list of custom_flags" do
    render "/custom_flags/index.html.erb"
    response.should have_tag("tr>td", "value for category", 2)
    response.should have_tag("tr>td", "value for reason", 2)
    response.should have_tag("tr>td", "value for type", 2)
  end
end

