# == Schema Information
# Schema version: 20081208201532
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

  named_scope :principal,:conditions=>{:is_principal=>true}

  validates_uniqueness_of :user_id, :scope=>[:group_id,:is_principal]
  validates_presence_of :user_id, :group_id
end
