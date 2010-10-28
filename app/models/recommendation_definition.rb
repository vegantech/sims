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

class RecommendationDefinition < ActiveRecord::Base
  has_many :checklist_definitions
  belongs_to :district
  has_many :recommendation_answer_definitions, :dependent => :destroy
end
