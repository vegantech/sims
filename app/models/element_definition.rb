# == Schema Information
# Schema version: 20081208201532
#
# Table name: element_definitions
#
#  id                     :integer         not null, primary key
#  question_definition_id :integer
#  text                   :text
#  kind                   :string(255)
#  position               :integer
#  created_at             :datetime
#  updated_at             :datetime
#

class ElementDefinition < ActiveRecord::Base
  belongs_to :question_definition

  has_many :answer_definitions, :dependent => :destroy, :order => "position ASC"
  has_many :answers, :through => :answer_definitions

  delegate :checklist_definition, :to => :question_definition

  acts_as_reportable if defined? Ruport
  acts_as_list :scope => :question_definition


  validates_presence_of :question_definition_id, :text, :kind
  validates_uniqueness_of :kind, :scope => :question_definition_id, :if => lambda{|e| !e.kind.blank? && e.kind.to_sym == :applicable} 

  after_create :move_to_top, :if => lambda{|e| !e.kind.blank? && e.kind.to_sym == :applicable}

  KINDS_OF_ELEMENTS = {  #:mcsa => "Multiple-Choice, Single Answer",
    :scale => "Scale",
    :sa => "Short Answer",
    :comment => "Comment",
  :decision => "Decision" ,
  :applicable => "Applicable Choice"}

  def self.kinds_of_elements
    KINDS_OF_ELEMENTS
  end

  def sibling_definitions
    question_definition.element_definitions
  end

  def self.new_from_existing(element_definition)
    new_element_definition = ElementDefinition.new(element_definition.attributes)
    element_definition.answer_definitions.each do |answer_definition|
      new_element_definition.answer_definitions << AnswerDefinition.new_from_existing(answer_definition)
    end
    new_element_definition
  end

  protected
  def validate
    unless errors.on :kind or ElementDefinition.kinds_of_elements.keys.include?(kind.to_sym)
      errors.add(:kind, "must have a one of the following kinds: #{ElementDefinition.kinds_of_elements.keys.to_sentence}")
    end
  end

  

end

