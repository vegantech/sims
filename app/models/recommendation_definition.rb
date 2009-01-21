# == Schema Information
# Schema version: 20090118224504
#
# Table name: recommendation_definitions
#
#  id                      :integer         not null, primary key
#  district_id             :integer
#  active                  :boolean
#  text                    :text
#  checklist_definition_id :integer
#  score_options           :integer
#  created_at              :datetime
#  updated_at              :datetime
#

class RecommendationDefinition < ActiveRecord::Base
  has_many :checklist_definitions
  belongs_to :district
  has_many :recommendation_answer_definitions, :dependent => :destroy
end
