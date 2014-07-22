# == Schema Information
# Schema version: 20101101011500
#
# Table name: enrollments
#
#  id         :integer(4)      not null, primary key
#  school_id  :integer(4)
#  student_id :integer(4)
#  grade      :string(16)
#  created_at :datetime
#  updated_at :datetime
#  end_year   :integer(4)
#

class Enrollment < ActiveRecord::Base
  CSV_HEADERS=[:grade, :district_school_id, :district_student_id, :end_year]
  belongs_to :student
  belongs_to :school

  validates_presence_of :grade,:school_id

  scope :by_student_ids_or_grades, lambda {|student_ids,grades| where( ["enrollments.student_id in (?) or enrollments.grade in (?)", Array(student_ids),Array(grades)])}

  def esl
    Student.columns_hash["esl"].type_cast(attributes['esl'])
  end

  def special_ed
    Student.columns_hash["special_ed"].type_cast(attributes['special_ed'])
  end

  def self.grades
    uniq.pluck(:grade)
  end
end
