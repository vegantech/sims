# == Schema Information
# Schema version: 20101027022939
#
# Table name: ext_siblings
#
#  id             :integer(4)      not null, primary key
#  student_id     :integer(4)
#  first_name     :string(255)
#  middle_name    :string(255)
#  last_name      :string(255)
#  student_number :string(255)
#  grade          :string(255)
#  school_name    :string(255)
#  age            :integer(4)
#  created_at     :datetime
#  updated_at     :datetime
#

class ExtSibling < ActiveRecord::Base
  belongs_to :student
end
