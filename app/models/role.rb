class Role < ActiveRecord::Base
  belongs_to :district
  belongs_to :state
  belongs_to :country

  acts_as_list # :scope =>[:district_id,:state_id, :country_id, :system]  need to fix this

  #  validate 
end
