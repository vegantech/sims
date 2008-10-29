class RecommendationAnswerDefinition < ActiveRecord::Base
  belongs_to :recommendation_definition
  has_many :recommendation_answers

  acts_as_list :scope=>:recommendation_definition_id

  validates_presence_of :text
end
