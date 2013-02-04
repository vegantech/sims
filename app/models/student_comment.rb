# == Schema Information
# Schema version: 20101101011500
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
  include LinkAndAttachmentAssets
  belongs_to :student, :touch => true
  belongs_to :user
  validates_presence_of :body
  attr_accessible :body, :existing_asset_attributes, :new_asset_attributes, :created_at

  define_statistic :team_notes , :count => :all, :joins => :student
  define_statistic :students_with_notes , :count => :all,  :column_name => 'distinct student_id', :joins => :student
  define_statistic :districts_with_team_notes, :count => :all, :column_name => 'distinct district_id', :joins => :student
  define_statistic :users_with_team_notes, :count => :all, :column_name => 'distinct user_id', :joins => :user


  def date_user_student_school_grade
    arr=[created_at.to_date, user.to_s]
    if student.present?
      arr |= [student.to_s, student.enrollments.first.grade, student.enrollments.first.school.to_s]
    else
      arr |=["No longer in sims",nil, nil]
    end

    arr

  end
end
