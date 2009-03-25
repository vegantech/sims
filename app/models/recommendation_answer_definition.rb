# == Schema Information
# Schema version: 20090316004509
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
  has_many :recommendation_answers, :dependent => :destroy

  acts_as_list :scope=>:recommendation_definition_id
  acts_as_paranoid

  validates_presence_of :text
end
