class Student < ActiveRecord::Base
  belongs_to :district
  has_many :enrollments
  has_many :schools, :through=>:enrollments
end
