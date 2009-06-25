# == Schema Information
# Schema version: 20090623023153
#
# Table name: recommendation_answer_definitions
#
#  id                           :integer(4)      not null, primary key
#  recommendation_definition_id :integer(4)
#  position                     :integer(4)
#  text                         :text
#  created_at                   :datetime
#  updated_at                   :datetime
#  deleted_at                   :datetime
#  copied_at                    :datetime
#  copied_from                  :integer(4)
#

class RecommendationAnswerDefinition < ActiveRecord::Base
  belongs_to :recommendation_definition
  has_many :recommendation_answers, :dependent => :destroy

  acts_as_list :scope=>:recommendation_definition_id
  is_paranoid

  validates_presence_of :text
end
