# == Schema Information
# Schema version: 20081030035908
#
# Table name: recommendations
#
#  id                           :integer         not null, primary key
#  progress                     :integer
#  recommendation               :integer
#  checklist_id                 :integer
#  user_id                      :integer
#  reason                       :text
#  should_advance               :boolean
#  created_at                   :datetime
#  updated_at                   :datetime
#  recommendation_definition_id :integer
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Recommendation do
  before(:each) do
    @valid_attributes = {
      :recommendation => "1",
      :draft=> true,
      :should_advance => false,
      :recommendation_definition=>RecommendationDefinition.new
    }
  end

  it "should create a new instance given valid attributes" do
    checklist=Checklist.new
#    checklist.should_receive(:score_checklist).and_return(true)
    Recommendation.create!(@valid_attributes.merge(:checklist=>checklist))
  end
end
