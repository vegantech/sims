require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RecommendationDefinition do
  before(:each) do
    @valid_attributes = {
      :district => ,
      :active => false,
      :text => "value for text",
      :checklist_definition => ,
      :score_options => "1"
    }
  end

  it "should create a new instance given valid attributes" do
    pending
    RecommendationDefinition.create!(@valid_attributes)
  end
end
