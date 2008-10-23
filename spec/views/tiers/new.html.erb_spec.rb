require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/tiers/new.html.erb" do
  include TiersHelper
  
  before(:each) do
    assigns[:tier] = stub_model(Tier,
      :new_record? => true,
      :title => "value for title",
      :position => "1"
    )
  end

  it "should render new form" do
    render "/tiers/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", tiers_path) do
      with_tag("input#tier_title[name=?]", "tier[title]")
      with_tag("input#tier_position[name=?]", "tier[position]")
    end
  end
end


