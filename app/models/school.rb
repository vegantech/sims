# == Schema Information
# Schema version: 20081208201532
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
  has_many :special_user_groups
  has_many :groups, :order => :title
  has_many :user_school_assignments, :dependent => :destroy
  has_many :users, :through=> :user_school_assignments
  has_many :quicklist_items

  has_many :quicklist_item_definitions, :class_name=>"InterventionDefinition", :through => :quicklist_items


  validates_presence_of :name,:district
  validates_uniqueness_of :name, :scope => :district_id



  def grades_by_user(user)
    school_grades = enrollments.grades
    if user.special_user_groups.all_students_in_school?(self)
      grades= school_grades
    else
      grades=[]
      school_grades.each do |grade|
        grades << grade if enrollments.by_student_ids_or_grades(nil,grade).student_belonging_to_user?(user)
      end
    end

    grades.sort!
    grades.unshift("*") if grades.size >1
    grades
  end

  def to_s
    name
  end

  def user_assignments=(sch)
    sch = Array(sch)
    sch.reject!(&:blank?)
    usa = sch.collect do |s|
      UserSchoolAssignment.new(s.merge(:school_id=>self.id))
    end
    self.user_school_assignments=usa
  end

  def virtual_groups
    virt_groups=[self.groups.build(:title=>"All Students In School")]
    enrollments.find(:all,:select=>"distinct grade").collect(&:grade).each do |grade|
      virt_groups <<  self.groups.build(:title=>"All Students In Grade: #{grade}")
    end
    virt_groups

  end



end
