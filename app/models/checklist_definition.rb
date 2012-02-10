# == Schema Information
# Schema version: 20101101011500
#
# Table name: checklist_definitions
#
#  id                           :integer(4)      not null, primary key
#  text                         :text
#  directions                   :text
#  active                       :boolean(1)
#  district_id                  :integer(4)
#  created_at                   :datetime
#  updated_at                   :datetime
#  recommendation_definition_id :integer(4)
#  document_file_name           :string(255)
#  document_content_type        :string(255)
#  document_file_size           :integer(4)
#  document_updated_at          :datetime
#

class ChecklistDefinition < ActiveRecord::Base
  belongs_to :district, :touch => true
  belongs_to :recommendation_definition
  has_many :question_definitions, :dependent => :destroy, :order => "position ASC"
  has_many :element_definitions, :through =>:question_definitions
  has_many :checklists

  has_attached_file  :document

  before_validation :clear_document
  validates_presence_of :directions, :text
  before_save :mark_other_checklist_definitions_inactive, :if => :active
  acts_as_reportable if defined? Ruport

  def save_all!
    save! and
    question_definitions.each(&:save!) and
    element_definitions.each(&:save!) and
    answer_definitions.each(&:save!)
  end

  def answer_definitions
    element_definitions.collect(&:answer_definitions).flatten
  end

  def self.active_checklist_definition
    find_by_active(true)
  end

  def answer_definitions2
    @answer_definitions||=AnswerDefinition.find(:all,
    :include=>[:element_definition=>{:question_definition=>:checklist_definition}],
    :joins=>"and question_definitions.checklist_definition_id=#{id}")
  end

  def checklist_definition_id
    id
  end

  def deep_clone

    k=clone
    k.active=false
    k.question_definitions = question_definitions.collect{|o| o.deep_clone}
    k.document=document
    k
  end

  def delete_document=(value)
    @delete_document = !value.to_i.zero?
  end

  def delete_document
    !!@delete_document
  end



  protected

  def mark_other_checklist_definitions_inactive
    if active?
      id_cond="id != #{id}" unless new_record?
      district.checklist_definitions.update_all('active=false', id_cond)
    end
  end

  def clear_document
     self.document=nil if @delete_document && !document.dirty?
  end

end
