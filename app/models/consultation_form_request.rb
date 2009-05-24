class ConsultationFormRequest < ActiveRecord::Base
  belongs_to :student
  belongs_to :requestor, :class_name => 'User'
  #  belongs_to :team
end
