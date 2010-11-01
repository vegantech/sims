# == Schema Information
# Schema version: 20101101011500
#
# Table name: answers
#
#  id                   :integer(4)      not null, primary key
#  checklist_id         :integer(4)
#  answer_definition_id :integer(4)
#  text                 :text
#  created_at           :datetime
#  updated_at           :datetime
#

class Answer < ActiveRecord::Base
  belongs_to :checklist
  belongs_to :answer_definition
  has_many :previous_answers, :class_name => 'Answer',
    :finder_sql => 'select * from answers where id = #{id} and checklist_id in (#{checklist.student.checklists.collect(&:checklist_id)}) and created_at < \' #{(checklist.created_at || Time.now).to_s(:db)}\' order by created_at ASC'

  delegate :value, :to => :answer_definition
  acts_as_reportable if defined? Ruport

  def self.find_all_by_element_definition(element_definition)
    find(:all, :conditions=>["answer_definition_id in ( ? ) ",element_definition.answer_definitions ])
  end
end
