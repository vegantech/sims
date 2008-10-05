require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/custom_flags/new.html.erb" do
  include CustomFlagsHelper
  
  before(:each) do
    assigns[:custom_flag] = stub_model(CustomFlag,
      :new_record? => true,
      :district => "value for district",
      :user => "value for user",
      :category => "value for category",
      :type => "value for type"
    )
  end

  it "should render new form" do
    render "/custom_flags/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", custom_flags_path) do
      with_tag("input#custom_flag_category[name=?]", "custom_flag[category]")
      with_tag("textarea#custom_flag_reason[name=?]", "custom_flag[reason]")
      with_tag("input#custom_flag_type[name=?]", "custom_flag[type]")
    end
  end
end


