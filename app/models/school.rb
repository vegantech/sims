class School < ActiveRecord::Base
  belongs_to :district
  has_and_belongs_to_many :users
end
