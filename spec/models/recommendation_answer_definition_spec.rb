require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RecommendationAnswerDefinition do
  before(:each) do
    @valid_attributes = {
      :position => "1",
      :text => "value for text"
    }
  end

  it "should create a new instance given valid attributes" do
    pending
    RecommendationAnswerDefinition.create!(@valid_attributes)
  end
end
