# == Schema Information
# Schema version: 20101027022939
#
# Table name: recommendation_definitions
#
#  id                      :integer(4)      not null, primary key
#  district_id             :integer(4)
#  active                  :boolean(1)
#  text                    :text
#  checklist_definition_id :integer(4)
#  score_options           :integer(4)
#  created_at              :datetime
#  updated_at              :datetime
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
