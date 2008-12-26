# == Schema Information
# Schema version: 20081223233819
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
  validates_uniqueness_of :kind, :scope => :question_definition_id, :if => :applicable_kind_uniqueness?

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

  def deep_clone(question_definition=nil)
    k=clone
    k.question_definition=question_definition
    k.answer_definitions = answer_definitions.collect{|o| o.deep_clone}
    k
  end


  protected
  def validate
    unless errors.on :kind or ElementDefinition.kinds_of_elements.keys.include?(kind.to_sym)
      errors.add(:kind, "must have a one of the following kinds: #{ElementDefinition.kinds_of_elements.keys.to_sentence}")
    end
  end

  def applicable_kind_uniqueness?
    !kind.blank?  && kind.to_sym == :applicable && !question_definition.new_record?
  end 

end

