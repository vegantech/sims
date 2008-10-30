require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Recommendation do
  before(:each) do
    @valid_attributes = {
      :progress => "1",
      :recommendation => "1",
      :reason => "value for reason",
      :should_advance => false,
      :recommendation_definition=>RecommendationDefinition.new
    }
  end

  it "should create a new instance given valid attributes" do
    checklist=Checklist.new
    checklist.should_receive(:score_checklist).and_return(true)
    Recommendation.create!(@valid_attributes.merge(:checklist=>checklist))
  end
end
