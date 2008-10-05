require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/ignore_flags/index.html.erb" do
  include IgnoreFlagsHelper
  
  before(:each) do
    assigns[:ignore_flags] = [
      stub_model(IgnoreFlag,
        :category => "value for category",
        :reason => "value for reason",
        :type => "value for type",
        :district => "district",
        :user => "user"
      ),
      stub_model(IgnoreFlag,
        :category => "value for category",
        :reason => "value for reason",
        :type => "value for type",
        :district => "district",
        :user => "user"
      )
    ]
  end

  it "should render list of ignore_flags" do
    render "/ignore_flags/index.html.erb"
    response.should have_tag("tr>td", "value for category", 2)
    response.should have_tag("tr>td", "value for reason", 2)
    response.should have_tag("tr>td", "value for type", 2)
  end
end

