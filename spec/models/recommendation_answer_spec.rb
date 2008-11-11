# == Schema Information
# Schema version: 20081111204313
#
# Table name: recommendation_answers
#
#  id                                  :integer         not null, primary key
#  recommendation_id                   :integer
#  recommendation_answer_definition_id :integer
#  text                                :text
#  created_at                          :datetime
#  updated_at                          :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RecommendationAnswer do
  before(:each) do
    @valid_attributes = {
      :text => "value for text"
    }
  end

  it "should create a new instance given valid attributes" do
    RecommendationAnswer.create!(@valid_attributes)
  end
end
