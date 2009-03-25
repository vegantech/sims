# == Schema Information
# Schema version: 20090325221606
#
# Table name: recommendation_answers
#
#  id                                  :integer         not null, primary key
#  recommendation_id                   :integer
#  recommendation_answer_definition_id :integer
#  text                                :text
#  created_at                          :datetime
#  updated_at                          :datetime
#

class RecommendationAnswer < ActiveRecord::Base
  belongs_to :recommendation_answer_definition
  belongs_to :recommendation
  attr_accessor :draft
  validates_presence_of :text, :if=>lambda{|r| !r.draft}
  validates_presence_of :recommendation_answer_definition_id

end
