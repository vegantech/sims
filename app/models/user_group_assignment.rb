# == Schema Information
# Schema version: 20101101011500
#
# Table name: user_group_assignments
#
#  id           :integer(4)      not null, primary key
#  user_id      :integer(4)
#  group_id     :integer(4)
#  is_principal :boolean(1)
#  created_at   :datetime
#  updated_at   :datetime
#

class UserGroupAssignment < ActiveRecord::Base
  belongs_to :user, inverse_of: :user_group_assignments
  belongs_to :group

  scope :principal, where(is_principal: true)
  scope :student_id_for_school, lambda{ |school|
    joins(:group).where(
      "groups.school_id" => school).joins(
      "inner join groups_students on
         groups_students.group_id = groups.id").select("
         groups_students.student_id")
  }


  validates_uniqueness_of :user_id, scope: :group_id, message: "-- Remove the user first"
  validates_presence_of :user, :group
end
