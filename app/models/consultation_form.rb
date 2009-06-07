# == Schema Information
# Schema version: 20090524185436
#
# Table name: consultation_forms
#
#  id                   :integer         not null, primary key
#  user_id              :integer
#  team_consultation_id :integer
#  do_differently       :text
#  parent_notified      :text
#  not_in_sims          :text
#  desired_outcome      :text
#  created_at           :datetime
#  updated_at           :datetime
#  student_id           :integer
#

class ConsultationForm < ActiveRecord::Base
  belongs_to :user
  belongs_to :team_consultation
  belongs_to :student
  has_many :consultation_form_concerns
  
  delegate :district,  :to => '(student or team_consultation or return nil)'

  accepts_nested_attributes_for :consultation_form_concerns

  FIELD_SIZE = '60x3'

  def build_concerns
     0.upto(ConsultationFormConcern::AREAS.length){|i| consultation_form_concerns.build(:area => i)} if consultation_form_concerns.blank?
  end
end
