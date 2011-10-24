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
  before_create :remove_if_duplicate

  private
  def remove_if_duplicate
     !StaffAssignment.find_by_user_id_and_school_id(user_id, school_id)
  end
end
