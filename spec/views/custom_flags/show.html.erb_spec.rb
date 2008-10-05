require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/custom_flags/show.html.erb" do
  include CustomFlagsHelper
  
  before(:each) do
    assigns[:custom_flag] = @custom_flag = stub_model(CustomFlag,
      :category => "value for category",
      :district => "value for district",
      :reason=> "value for reason",
      :user => "value for user",
      :type => "value for type"
    )
  end

  it "should render attributes in <p>" do
    render "/custom_flags/show.html.erb"
    response.should have_text(/value\ for\ category/)
    response.should have_text(/value\ for\ reason/)
    response.should have_text(/value\ for\ type/)
  end
end

