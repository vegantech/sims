# == Schema Information
# Schema version: 20101101011500
#
# Table name: recommendation_definitions
#
#  id                      :integer(4)      not null, primary key
#  active                  :boolean(1)
#  text                    :text
#  checklist_definition_id :integer(4)
#  score_options           :integer(4)
#  created_at              :datetime
#  updated_at              :datetime
#

class RecommendationDefinition < ActiveRecord::Base
  has_many :checklist_definitions
  has_many :recommendation_answer_definitions, dependent: :destroy
  scope :content_export, order
end
