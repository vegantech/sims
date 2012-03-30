# == Schema Information
# Schema version: 20101101011500
#
# Table name: element_definitions
#
#  id                     :integer(4)      not null, primary key
#  question_definition_id :integer(4)
#  text                   :text
#  kind                   :string(255)
#  position               :integer(4)
#  created_at             :datetime
#  updated_at             :datetime
#

class ElementDefinition < ActiveRecord::Base
  KINDS_OF_ELEMENTS = {
    :scale => "Scale",
    :sa => "Short Answer",
    :comment => "Comment",
    :applicable => "Applicable Choice"
  }

  belongs_to :question_definition

  has_many :answer_definitions, :dependent => :destroy, :order => "position ASC"
  has_many :answers, :through => :answer_definitions

  delegate :checklist_definition, :to => :question_definition

  acts_as_list :scope => :question_definition


  validates_presence_of :question_definition_id,  :kind
  validates_presence_of :text, :unless =>:applicable_kind?
  validates_uniqueness_of :kind, :scope => [:question_definition_id], :if => :applicable_kind_uniqueness?
  validates_inclusion_of :kind, :in => KINDS_OF_ELEMENTS.keys.collect(&:to_s), :message => "must have a one of the following kinds: #{KINDS_OF_ELEMENTS.keys.to_sentence}"

  after_create :move_to_top, :if => :applicable_kind?

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

  def has_answers?
    Answer.count(:include => :answer_definition, :conditions => "answer_definitions.id = #{id}" ) > 0
  end


  protected
  def applicable_kind_uniqueness?
    applicable_kind? && (!question_definition || !question_definition.new_record?)
  end

  def applicable_kind?
    !kind.blank?  && kind.to_sym == :applicable
  end
end

