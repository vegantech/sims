# == Schema Information
# Schema version: 20090623023153
#
# Table name: student_comments
#
#  id         :integer(4)      not null, primary key
#  student_id :integer(4)
#  user_id    :integer(4)
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#


#Also known as team_note
class StudentComment < ActiveRecord::Base
  belongs_to :student
  belongs_to :user
  validates_presence_of :body

  acts_as_reportable if defined? Ruport
end
