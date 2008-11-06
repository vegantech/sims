# == Schema Information
# Schema version: 20081030035908
#
# Table name: user_group_assignments
#
#  id           :integer         not null, primary key
#  user_id      :integer
#  group_id     :integer
#  is_principal :boolean
#  created_at   :datetime
#  updated_at   :datetime
#

class UserGroupAssignment < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
end