# == Schema Information
# Schema version: 20090316004509
#
# Table name: recommendation_answer_definitions
#
#  id                           :integer         not null, primary key
#  recommendation_definition_id :integer
#  position                     :integer
#  text                         :text
#  created_at                   :datetime
#  updated_at                   :datetime
#

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
