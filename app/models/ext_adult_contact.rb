# == Schema Information
# Schema version: 20101027022939
#
# Table name: ext_adult_contacts
#
#  id            :integer(4)      not null, primary key
#  student_id    :integer(4)
#  relationship  :string(255)
#  guardian      :boolean(1)
#  firstName     :string(255)
#  lastName      :string(255)
#  homePhone     :string(255)
#  workPhone     :string(255)
#  cellPhone     :string(255)
#  pager         :string(255)
#  email         :string(255)
#  streetAddress :string(255)
#  cityStateZip  :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class ExtAdultContact < ActiveRecord::Base
  belongs_to :student
end
