# == Schema Information
# Schema version: 20090118224504
#
# Table name: user_school_assignments
#
#  id         :integer         not null, primary key
#  school_id  :integer
#  user_id    :integer
#  admin      :boolean
#  created_at :datetime
#  updated_at :datetime
#

class UserSchoolAssignment < ActiveRecord::Base
  belongs_to :school
  belongs_to :user
  # validates_presence_of :school_id
  validates_presence_of :user_id

  named_scope :admin, :conditions=>{:admin=>true}
end