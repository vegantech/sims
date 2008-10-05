require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/ignore_flags/edit.html.erb" do
  include IgnoreFlagsHelper
  
  before(:each) do
    assigns[:ignore_flag] = @ignore_flag = stub_model(IgnoreFlag,
      :new_record? => false,
      :category => "value for category",
      :reason => "value for reason",
      :district => "district",
      :user => "user",
      :type => "value for type"
    )
  end

  it "should render edit form" do
    render "/ignore_flags/edit.html.erb"
    
    response.should have_tag("form[action=#{ignore_flag_path(@ignore_flag)}][method=post]") do
      with_tag('input#ignore_flag_category[name=?]', "ignore_flag[category]")
      with_tag('textarea#ignore_flag_reason[name=?]', "ignore_flag[reason]")
      with_tag('input#ignore_flag_type[name=?]', "ignore_flag[type]")
    end
  end
end


