require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/tiers/edit.html.erb" do
  include TiersHelper
  
  before(:each) do
    assigns[:tier] = @tier = stub_model(Tier,
      :new_record? => false,
      :title => "value for title",
      :position => "1"
    )
  end

  it "should render edit form" do
    render "/tiers/edit.html.erb"
    
    response.should have_tag("form[action=#{tier_path(@tier)}][method=post]") do
      with_tag('input#tier_title[name=?]', "tier[title]")
      with_tag('input#tier_position[name=?]', "tier[position]")
    end
  end
end


