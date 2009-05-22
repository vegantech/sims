class ConsultationFormRequest < ActiveRecord::Base
  belongs_to :student
  belongs_to :requestor
  has_many :consultation_forms
  accepts_nested_attributes_for :consultation_forms
    
end
