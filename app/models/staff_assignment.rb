# == Schema Information
# Schema version: 20101101011500
#
# Table name: staff_assignments
#
#  id        :integer(4)      not null, primary key
#  school_id :integer(4)
#  user_id   :integer(4)
#

class StaffAssignment < ActiveRecord::Base
  belongs_to :school
  belongs_to :user
end
