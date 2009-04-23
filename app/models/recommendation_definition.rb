# == Schema Information
# Schema version: 20090325230037
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
#  deleted_at              :datetime
#  copied_at               :datetime
#  copied_from             :integer
#

class RecommendationDefinition < ActiveRecord::Base
  has_many :checklist_definitions
  belongs_to :district
  has_many :recommendation_answer_definitions, :dependent => :destroy
  is_paranoid
end
