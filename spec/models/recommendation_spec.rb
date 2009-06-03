# == Schema Information
# Schema version: 20090524185436
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
#  draft                        :boolean
#  district_id                  :integer
#  tier_id                      :integer
#  student_id                   :integer
#  promoted                     :boolean
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


  it "should show previous answers" do
    pending "Use a factory"
    #be sure to test with an existing rec to make sure newer ones don't appear
    #and a new one to male sure all previous are there

  end

  describe 'max_tier' do
    it 'should return nil when there are no checklists' do
      Recommendation.max_tier.should be_nil
    end

    it 'should return the tier of the highest promoted recommendation' do
      pending
    end
  end


end
