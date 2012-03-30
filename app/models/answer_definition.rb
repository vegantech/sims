# == Schema Information
# Schema version: 20101101011500
#
# Table name: answer_definitions
#
#  id                    :integer(4)      not null, primary key
#  element_definition_id :integer(4)
#  text                  :text
#  value                 :string(255)
#  position              :integer(4)
#  autoset_others        :boolean(1)
#  created_at            :datetime
#  updated_at            :datetime
#

class AnswerDefinition < ActiveRecord::Base
  acts_as_list :scope => :element_definition

  belongs_to :element_definition
  has_many :answers

  delegate :question_definition, :to => :element_definition
  delegate :checklist_definition, :to => :question_definition

  validates_presence_of  :value

  def sibling_definitions
    element_definition.answer_definitions
  end

  def deep_clone
    clone
  end

  def has_answers?
    answers.any?
  end

end
