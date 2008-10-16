class District < ActiveRecord::Base
  belongs_to :state
  has_many :users
  has_many :checklist_definitions
  has_many :goal_definitions, :order=>:position
  has_many :probe_definitions
end
