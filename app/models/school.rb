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
  has_many :personal_groups
  has_many :cico_settings
  attr_protected :district_id


  has_many :quicklist_interventions, :class_name=>"InterventionDefinition", :through => :quicklist_items, :source=>"intervention_definition"

  define_statistic :schools_with_enrollments , :count => :all, :joins => :enrollments, :select => 'distinct schools.id',
    :filter_on => {:created_after => "enrollments.created_at >= ?", :created_before => "enrollments.created_at <= ?"}
  define_statistic :districts_having_schools_with_enrollments , :count => :all, :joins => :enrollments, :select => 'distinct schools.district_id',
    :filter_on => {:created_after => "enrollments.created_at >= ?", :created_before => "enrollments.created_at <= ?"}

  validates_presence_of :name,:district
  validates_uniqueness_of :name, :scope => :district_id

  validate :validate_unique_user_school_assignments
  def validate_unique_user_school_assignments
    validate_uniqueness_of_in_memory(
      user_school_assignments, [:user_id, :admin], 'Duplicate User.')
  end


  def grades_by_user(user)
    if user.all_students_in_school?(self)
      grades = enrollments.grades
    else
      # all grades where user has 1 or more authorized enrollments
      grades = user.special_user_groups.grades_for_school(self)
      group_ids = (self.group_ids & user.group_ids) #This needs to be limited to the school
      sql = enrollments.select('distinct grade')
      sql = sql.joins 'join groups_students on enrollments.student_id = groups_students.student_id'
      sql = sql.where  'groups_students.group_id' => group_ids
      grades |= enrollments.connection.select_values(sql.to_sql)
    end
    grades.sort!
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
    enrollments.grades.each do |grade|
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
      user_school_assignment.save
    end
  end

  def enrollment_years
    sql = enrollments.select('distinct end_year').order('end_year')
    connection.select_values(sql.to_sql).collect(&:to_s)
  end

  def assigned_users
    s= staff.find(:all,:order=>'last_name,first_name', :select => "distinct users.*")
    if s.blank?
      users.find(:all,:order=>'last_name,first_name', :select => "distinct users.*")
    else
      s
    end
  end

  def cico_enabled?(probe_definition)
    r=cico_settings.find_by_probe_definition_id(probe_definition.id)
    r && r.enabled?
  end

end
