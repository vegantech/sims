class District < ActiveRecord::Base
  belongs_to :state
  has_many :users
  has_many :checklist_definitions
end
