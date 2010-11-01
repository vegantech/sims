# == Schema Information
# Schema version: 20101101011500
#
# Table name: recommendation_answers
#
#  id                                  :integer(4)      not null, primary key
#  recommendation_id                   :integer(4)
#  recommendation_answer_definition_id :integer(4)
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
