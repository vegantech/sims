# == Schema Information
# Schema version: 20090428193630
#
# Table name: recommendation_definitions
#
#  id                      :integer         not null, primary key
#  district_id             :integer
#  active                  :boolean
#  text                    :text
#  checklist_definition_id :integer
#  score_options           :integer
#  created_at              :datetime
#  updated_at              :datetime
#  deleted_at              :datetime
#  copied_at               :datetime
#  copied_from             :integer
#

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
