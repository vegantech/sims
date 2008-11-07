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
    school_grades = enrollments.find(:all,:select=>"distinct grade").collect(&:grade)  #call this self.grades in enrollments
    if user.special_user_groups.all_students_in_school?(self)
      return school_grades
    end
    
    grades=user.special_user_groups.find_all_by_type("all_students_in_school", :conditions=>"grade is not null").collect(&:grade).uniq  #clean this up,   probably method in special user group

    (school_grades - grades).each do |grade|
      grades << grade if enrollments.student_in_this_grade_belonging_to_user?(grade,user)
    end
    grades


  end


end
