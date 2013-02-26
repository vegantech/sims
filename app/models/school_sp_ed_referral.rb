class SchoolSpEdReferral < ActiveRecord::Base
  attr_accessible  :email, :name
  belongs_to :school
end
