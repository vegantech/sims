class QuicklistItem < ActiveRecord::Base
  belongs_to :district
  belongs_to :school
  belongs_to :intervention_definition

end
