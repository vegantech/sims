# == Schema Information
# Schema version: 20090524185436
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
#  deleted_at            :datetime
#  copied_at             :datetime
#  copied_from           :integer
#

class AnswerDefinition < ActiveRecord::Base
  acts_as_list :scope => :element_definition
  is_paranoid

  belongs_to :element_definition

  delegate :question_definition, :to => :element_definition
  delegate :checklist_definition, :to => :question_definition

  acts_as_reportable if defined? Ruport

  validates_presence_of  :value

  def sibling_definitions
    element_definition.answer_definitions
  end

  def deep_clone
    clone
  end

end
