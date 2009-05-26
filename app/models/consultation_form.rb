class ConsultationForm < ActiveRecord::Base
  belongs_to :user
  belongs_to :team_consultation
  belongs_to :student
  has_many :consultation_form_concerns
  

  accepts_nested_attributes_for :consultation_form_concerns

  FIELD_SIZE='60x3'

  
  def build_concerns
     0.upto(ConsultationFormConcern::AREAS.length){|i| consultation_form_concerns.build(:area => i)} if consultation_form_concerns.blank?
  end
end
