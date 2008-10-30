require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RecommendationDefinition do
  before(:each) do
    @valid_attributes = {
      :active => false,
      :text => "value for text",
      :score_options => "1"
    }
  end

  it "should create a new instance given valid attributes" do
    RecommendationDefinition.create!(@valid_attributes)
  end
end
