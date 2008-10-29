class RecommendationAnswer < ActiveRecord::Base
  belongs_to :recommendation_answer_definition
  belongs_to :recommendation

  validates_presence_of :text
end
