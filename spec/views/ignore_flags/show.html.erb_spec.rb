require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/ignore_flags/show.html.erb" do
  include IgnoreFlagsHelper
  
  before(:each) do
    assigns[:ignore_flag] = @ignore_flag = stub_model(IgnoreFlag,
      :category => "value for category",
      :reason => "value for reason",
      :district => "district",
      :user => "user",
      :type => "value for type"
    )
  end

  it "should render attributes in <p>" do
    render "/ignore_flags/show.html.erb"
    response.should have_text(/value\ for\ category/)
    response.should have_text(//)
    response.should have_text(//)
    response.should have_text(/value\ for\ reason/)
    response.should have_text(/value\ for\ type/)
  end
end

