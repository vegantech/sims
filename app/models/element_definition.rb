# == Schema Information
# Schema version: 20090428193630
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
#  deleted_at             :datetime
#  copied_at              :datetime
#  copied_from            :integer
#

class ElementDefinition < ActiveRecord::Base
  belongs_to :question_definition

  has_many :answer_definitions, :dependent => :destroy, :order => "position ASC"
  has_many :answers, :through => :answer_definitions

  delegate :checklist_definition, :to => :question_definition

  acts_as_reportable if defined? Ruport
  acts_as_list :scope => :question_definition
  is_paranoid


  validates_presence_of :question_definition_id,  :kind
  validates_presence_of :text, :unless =>:applicable_kind?
  validates_uniqueness_of :kind, :scope => [:question_definition_id, :deleted_at], :if => :applicable_kind_uniqueness?

  after_create :move_to_top, :if => :applicable_kind?

  KINDS_OF_ELEMENTS = { 
    :scale => "Scale",
    :sa => "Short Answer",
    :comment => "Comment",
    :applicable => "Applicable Choice"
  }

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
    applicable_kind? && (!question_definition || !question_definition.new_record?)
  end 

  def applicable_kind?
    !kind.blank?  && kind.to_sym == :applicable 
  end

end

