class School < ActiveRecord::Base
  belongs_to :district
  has_many :enrollments
  has_many :students, :through =>:enrollments
  has_many :groups
  has_and_belongs_to_many :users
end
