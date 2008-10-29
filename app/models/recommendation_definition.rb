class RecommendationDefinition < ActiveRecord::Base
  belongs_to :checklist_definition
  belongs_to :district
  has_many :recommendation_answer_definitions
end
