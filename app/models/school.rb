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
  belongs_to :district
  has_many :enrollments, dependent: :destroy
  has_many :students, through: :enrollments
  has_many :special_user_groups, dependent: :destroy
  has_many :groups, order: :title, dependent: :destroy
  has_many :user_school_assignments, dependent: :destroy
  has_many :users, through: :user_school_assignments
  has_many :quicklist_items, dependent: :destroy
  has_many :school_teams, dependent: :destroy
  has_many :staff_assignments
  has_many :staff, through: :staff_assignments, source: :user
  has_many :personal_groups
  has_many :quicklist_interventions, class_name: "InterventionDefinition", through: :quicklist_items, source: "intervention_definition"
  has_one :school_sp_ed_referral, dependent: :destroy
  accepts_nested_attributes_for :user_school_assignments, allow_destroy: true

  attr_protected :district_id

  define_statistic :schools_with_enrollments , count: :all, joins: :enrollments, column_name: 'distinct schools.id',
                                               filter_on: {created_after: "enrollments.created_at >= ?", created_before: "enrollments.created_at <= ?"}
  define_statistic :districts_having_schools_with_enrollments , count: :all, joins: :enrollments, column_name: 'distinct schools.district_id',
                                                                filter_on: {created_after: "enrollments.created_at >= ?", created_before: "enrollments.created_at <= ?"}

  validates_presence_of :name,:district
  validates_uniqueness_of :name, scope: :district_id

  validate :validate_unique_user_school_assignments
  def validate_unique_user_school_assignments
    validate_uniqueness_of_in_memory(
      user_school_assignments, [:user_id, :admin], 'Duplicate User.')
  end

  scope :district, joins("inner join districts on districts.id = schools.district_id")

  def grades_by_user(user)
    if user.all_students_in_school?(self)
      grades = enrollments.grades
    else
      # all grades where user has 1 or more authorized enrollments
      grades = user.special_user_groups.grades_for_school(self)
      group_ids = (self.group_ids & user.group_ids) # This needs to be limited to the school
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

  def virtual_groups
    special_user_groups.virtual_groups(enrollments.grades)
  end

  def quicklist
    InterventionDefinition.joins(:quicklist_items).where(
      ["quicklist_items.district_id = ? or quicklist_items.school_id =?", self.district_id, self.id ])
  end

  def enrollment_years
    sql = enrollments.select('distinct end_year').order('end_year')
    connection.select_values(sql.to_sql).collect(&:to_s)
  end

  def assigned_users
    s= staff.order('last_name,first_name').select("distinct users.*")
    if s.blank?
      users.order('last_name,first_name').select("distinct users.*")
    else
      s
    end
  end
end
