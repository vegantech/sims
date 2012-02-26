# == Schema Information
# Schema version: 20101101011500
#
# Table name: recommendations
#
#  id                           :integer(4)      not null, primary key
#  progress                     :integer(4)
#  recommendation               :integer(4)
#  checklist_id                 :integer(4)
#  user_id                      :integer(4)
#  other                        :text
#  should_advance               :boolean(1)
#  created_at                   :datetime
#  updated_at                   :datetime
#  recommendation_definition_id :integer(4)
#  draft                        :boolean(1)
#  district_id                  :integer(4)
#  tier_id                      :integer(4)
#  student_id                   :integer(4)
#  promoted                     :boolean(1)
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
    checklist=Factory(:checklist)
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
