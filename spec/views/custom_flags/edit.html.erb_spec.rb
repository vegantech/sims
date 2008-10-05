require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/custom_flags/edit.html.erb" do
  include CustomFlagsHelper
  
  before(:each) do
    assigns[:custom_flag] = @custom_flag = stub_model(CustomFlag,
      :new_record? => false,
      :district => "value for district",
      :user => "value for user",
      :category => "value for category",
      :reason => "value for reason",
      :type => "value for type"
    )
  end

  it "should render edit form" do
    render "/custom_flags/edit.html.erb"
    
    response.should have_tag("form[action=#{custom_flag_path(@custom_flag)}][method=post]") do
      with_tag('input#custom_flag_category[name=?]', "custom_flag[category]")
      with_tag('textarea#custom_flag_reason[name=?]', "custom_flag[reason]")
      with_tag('input#custom_flag_type[name=?]', "custom_flag[type]")
    end
  end
end


