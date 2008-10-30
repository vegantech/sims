# == Schema Information
# Schema version: 20081030035908
#
# Table name: answer_definitions
#
#  id                    :integer         not null, primary key
#  element_definition_id :integer
#  text                  :text
#  value                 :string(255)
#  position              :integer
#  autoset_others        :boolean
#  created_at            :datetime
#  updated_at            :datetime
#

class AnswerDefinition < ActiveRecord::Base
  acts_as_list :scope => :element_definition

  belongs_to :element_definition
  acts_as_reportable if defined? Ruport

  validates_presence_of :element_definition_id, :value

  def checklist_definition
    element_definition.checklist_definition
  end

  def question_definition
    element_definition.question_definition
  end

  def sibling_definitions
    element_definition.answer_definitions
  end

  def self.new_from_existing(answer_definition)
    AnswerDefinition.new(answer_definition.attributes)
  end

end
