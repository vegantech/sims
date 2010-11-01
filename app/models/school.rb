# == Schema Information
# Schema version: 20101101011500
#
# Table name: schools
#
#  id                 :integer(4)      not null, primary key
#  name               :string(255)
#  district_school_id :integer(4)
#  id_state           :integer(4)
#  id_country         :integer(4)
#  district_id        :integer(4)
#  created_at         :datetime
#  updated_at         :datetime
#

class School < ActiveRecord::Base
  after_update :save_user_school_assignments

  belongs_to :district
  has_many :enrollments, :dependent => :destroy
  has_many :students, :through =>:enrollments
  has_many :special_user_groups, :dependent => :destroy
  has_many :groups, :order => :title, :dependent => :destroy
  has_many :user_school_assignments, :dependent => :destroy
  has_many :users, :through=> :user_school_assignments
  has_many :quicklist_items, :dependent => :destroy
  has_many :school_teams, :dependent => :destroy
  has_many :staff_assignments
  has_many :staff, :through => :staff_assignments, :source => :user


  has_many :quicklist_interventions, :class_name=>"InterventionDefinition", :through => :quicklist_items, :source=>"intervention_definition"

  define_statistic :schools_with_enrollments , :count => :all, :joins => :enrollments, :select => 'distinct schools.id', 
    :filter_on => {:created_after => "enrollments.created_at >= ?", :created_before => "enrollments.created_at <= ?"}
  define_statistic :districts_having_schools_with_enrollments , :count => :all, :joins => :enrollments, :select => 'distinct schools.district_id',
    :filter_on => {:created_after => "enrollments.created_at >= ?", :created_before => "enrollments.created_at <= ?"}

  validates_presence_of :name,:district
  validates_uniqueness_of :name, :scope => :district_id

  def grades_by_user(user)
    school_grades = enrollments.grades
    if user.special_user_groups.all_students_in_school?(self)
      grades = school_grades
    else
      # all grades where user has 1 or more authorized enrollments
      grades = user.special_user_groups.grades_for_school(self)
      student_ids = user.groups.find_all_by_school_id(self.id).collect(&:student_ids).flatten.uniq
      grades |= enrollments.find_all_by_student_id(student_ids, :select => "distinct grade").collect(&:grade)
    end

    grades.sort!
    grades.unshift("*") if grades.size > 1
    grades
  end

  def to_s
    name
  end

  def existing_user_school_assignment_attributes=(user_school_assignment_attributes)
    user_school_assignments.reject(&:new_record?).each do |user_school_assignment|
      attributes = user_school_assignment_attributes[user_school_assignment.id.to_s]

      if attributes
        user_school_assignment.attributes = attributes
      else
        user_school_assignments.delete(user_school_assignment)
      end
    end
  end

  def new_user_school_assignment_attributes=(usa_attributes)
    usa_attributes.each do |attributes|
      user_school_assignments.build(attributes)
    end
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

  def save_user_school_assignments
    user_school_assignments.each do |user_school_assignment|
      user_school_assignment.save(false)
    end
  end

  def enrollment_years 
    enrollments.all(:select=>'distinct end_year', :order =>'end_year').collect{|e| e.end_year.to_s}.unshift(["All","*"])
  end

  def assigned_users
    s= staff.find(:all,:order=>'last_name,first_name') 
    if s.blank?
      users.find(:all,:order=>'last_name,first_name')
    else 
      s
    end
  end
end
