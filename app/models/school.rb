# == Schema Information
# Schema version: 20081030035908
#
# Table name: schools
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  id_district :integer
#  id_state    :integer
#  id_country  :integer
#  district_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class School < ActiveRecord::Base
  belongs_to :district
  has_many :enrollments
  has_many :students, :through =>:enrollments
  has_many :groups
  has_and_belongs_to_many :users



  def grades_by_user(user)
    school_grades = enrollments.grades
    if user.special_user_groups.all_students_in_school?(self)
      grades= school_grades
    else
      grades=user.special_user_groups.grades_for_school(self)

      (school_grades - grades).each do |grade|
        grades << grade if enrollments.student_in_this_grade_belonging_to_user?(grade,user)
      end
    end

    grades.unshift("*") if grades.size >1
    grades
  end


end
