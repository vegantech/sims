require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/ignore_flags/new.html.erb" do
  include IgnoreFlagsHelper
  
  before(:each) do
    assigns[:ignore_flag] = stub_model(IgnoreFlag,
      :new_record? => true,
      :category => "value for category",
      :type => "value for type",
      :district => "district",
      :user => "user"
    )
  end

  it "should render new form" do
    render "/ignore_flags/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", ignore_flags_path) do
      with_tag("input#ignore_flag_category[name=?]", "ignore_flag[category]")
      with_tag("textarea#ignore_flag_reason[name=?]", "ignore_flag[reason]")
      with_tag("input#ignore_flag_type[name=?]", "ignore_flag[type]")
    end
  end
end


