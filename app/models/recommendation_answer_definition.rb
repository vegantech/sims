# == Schema Information
# Schema version: 20081111204313
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

class RecommendationAnswerDefinition < ActiveRecord::Base
  belongs_to :recommendation_definition
  has_many :recommendation_answers

  acts_as_list :scope=>:recommendation_definition_id

  validates_presence_of :text
end
