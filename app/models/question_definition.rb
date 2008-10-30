# == Schema Information
# Schema version: 20081030035908
#
# Table name: question_definitions
#
#  id                      :integer         not null, primary key
#  checklist_definition_id :integer
#  text                    :text
#  position                :integer
#  created_at              :datetime
#  updated_at              :datetime
#

class QuestionDefinition < ActiveRecord::Base

  acts_as_list :scope => :checklist_definition

  belongs_to :checklist_definition

  has_many :element_definitions, :dependent => :destroy, :order => "position ASC"
  has_many :answer_definitions, :through=> :element_definitions
  acts_as_reportable if defined? Ruport

  validates_presence_of :text, :checklist_definition_id

  def sibling_definitions
    checklist_definition.question_definitions
  end

  def self.new_from_existing(question_definition)
    new_question_definition = QuestionDefinition.new(question_definition.attributes)
    question_definition.element_definitions.each do |element_definition|
      new_question_definition.element_definitions << ElementDefinition.new_from_existing(element_definition)
    end
    new_question_definition
  end

end
