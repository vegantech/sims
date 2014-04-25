# == Schema Information
# Schema version: 20101101011500
#
# Table name: recommendation_answers
#
#  id                                  :integer(4)      not null, primary key
#  recommendation_id                   :integer(4)
#  recommendation_answer_definition_id :integer(4)
#  text                                :text
#  created_at                          :datetime
#  updated_at                          :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RecommendationAnswer do
  before(:each) do
    @valid_attributes = {
      text: "value for text",
      recommendation_answer_definition_id: 1
    }
  end

  it "should create a new instance given valid attributes" do
    RecommendationAnswer.create!(@valid_attributes)
  end
end
