# == Schema Information
# Schema version: 20101101011500
#
# Table name: question_definitions
#
#  id                      :integer(4)      not null, primary key
#  checklist_definition_id :integer(4)
#  text                    :text
#  position                :integer(4)
#  created_at              :datetime
#  updated_at              :datetime
#

class QuestionDefinition < ActiveRecord::Base
  belongs_to :checklist_definition

  has_many :element_definitions, dependent: :destroy, order: "position ASC"
  has_many :answer_definitions, through: :element_definitions
  acts_as_list scope: :checklist_definition

  validates_presence_of :text
  scope :content_export, order

  def sibling_definitions
    checklist_definition.question_definitions
  end

  def deep_clone
    k=clone
    k.element_definitions = element_definitions.collect{|o| o.deep_clone(k)}
    k
  end

  def has_answers?
    Answer.count(include: {answer_definition: :element_definition}, conditions: "element_definitions.id = #{id}" ) > 0
  end
end
