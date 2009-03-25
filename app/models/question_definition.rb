# == Schema Information
# Schema version: 20090325230037
#
# Table name: question_definitions
#
#  id                      :integer         not null, primary key
#  checklist_definition_id :integer
#  text                    :text
#  position                :integer
#  created_at              :datetime
#  updated_at              :datetime
#  deleted_at              :datetime
#  copied_at               :datetime
#  copied_from             :integer
#

class QuestionDefinition < ActiveRecord::Base
  belongs_to :checklist_definition

  has_many :element_definitions, :dependent => :destroy, :order => "position ASC"
  has_many :answer_definitions, :through=> :element_definitions
  acts_as_reportable if defined? Ruport
  acts_as_list :scope => :checklist_definition
  acts_as_paranoid

  validates_presence_of :text

  def sibling_definitions
    checklist_definition.question_definitions
  end

  def deep_clone
    k=clone
    k.element_definitions = element_definitions.collect{|o| o.deep_clone(k)}
    k
  end

end
