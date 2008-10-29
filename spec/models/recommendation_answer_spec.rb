require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RecommendationAnswer do
  before(:each) do
    @valid_attributes = {
      :recommendation => ,
      :recommendation_answer_definition => ,
      :text => "value for text"
    }
  end

  it "should create a new instance given valid attributes" do
    pending
    RecommendationAnswer.create!(@valid_attributes)
  end
end
