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
