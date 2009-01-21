# == Schema Information
# Schema version: 20090118224504
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
  ActiveSupport::Dependencies.load_missing_constant self, :StudentsController

  belongs_to :district
  has_many :enrollments 
  has_many :students, :through =>:enrollments
  has_many :special_user_groups
  has_many :groups, :order => :title
  has_many :user_school_assignments, :dependent => :destroy
  has_many :users, :through=> :user_school_assignments
  has_many :quicklist_items, :dependent => :destroy

  has_many :quicklist_interventions, :class_name=>"InterventionDefinition", :through => :quicklist_items, :source=>"intervention_definition"


  validates_presence_of :name,:district
  validates_uniqueness_of :name, :scope => :district_id



  def grades_by_user(user)
    school_grades = enrollments.grades
    if user.special_user_groups.all_students_in_school?(self)
      grades= school_grades
    else
      #all grades where user has 1 or more authorized enrollments
      grades=user.special_user_groups.grades_for_school(self)
      student_ids = user.groups.find_all_by_school_id(self.id).collect(&:student_ids).flatten.uniq
      grades |= enrollments.find_all_by_student_id(student_ids, :select => "distinct grade").collect(&:grade)
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


  def quicklist
    InterventionDefinition.find(:all,:joins=>:quicklist_items, 
    :conditions => ["quicklist_items.district_id = ? or quicklist_items.school_id =?", self.district_id, self.id ])
  end

end
