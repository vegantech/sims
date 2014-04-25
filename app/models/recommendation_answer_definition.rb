# == Schema Information
# Schema version: 20101101011500
#
# Table name: recommendation_answer_definitions
#
#  id                           :integer(4)      not null, primary key
#  recommendation_definition_id :integer(4)
#  position                     :integer(4)
#  text                         :text
#  created_at                   :datetime
#  updated_at                   :datetime
#

class RecommendationAnswerDefinition < ActiveRecord::Base
  belongs_to :recommendation_definition
  has_many :recommendation_answers, dependent: :destroy


  scope :content_export, order

  acts_as_list scope: :recommendation_definition_id

  validates_presence_of :text
end
