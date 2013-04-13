# == Schema Information
# Schema version: 20101101011500
#
# Table name: groups
#
#  id                :integer(4)      not null, primary key
#  title             :string(255)
#  school_id         :integer(4)
#  created_at        :datetime
#  updated_at        :datetime
#  district_group_id :string(255)
#

class Group < ActiveRecord::Base
  DESCRIPTION="
  This feature allows administrators to set up and edit groups that are used to assign students to staff.
  The most common group is sections of classes which are assigned by the school administrator or uploaded by the local systems administrator.
  The other common group is a group of students that have the same interventions and progress monitors
  which allows staff to enter progress monitoring data for all the students in the group on one screen."
  include Pageable
  belongs_to :school
  has_and_belongs_to_many :students
  has_many :user_group_assignments
  has_many :users, :through=>:user_group_assignments
  validates_presence_of :title, :school_id
  validates_uniqueness_of :title, :scope=>:school_id

  scope :by_school, lambda { |school| where(:school_id => school)}
  #doing the joins for by_grade was 3x slower, so we're using exists in a subquery
  scope :by_grade, lambda { |grade| where(["exists(select 1 from enrollments inner join groups_students on enrollments.student_id = groups_students.student_id where enrollments.school_id = groups.school_id
  and enrollments.student_id = groups_students.student_id and groups_students.group_id = groups.id and grade = ? ) ",grade])}
  scope :only_title_and_id, select('groups.id, groups.title')
  def self.members
    #TODO tested, but it is ugly and should be refactored
    group_ids=find(:all,:select=>"groups.id")
    User.find(:all,:select => 'distinct users.*',:joins => :groups ,:conditions=> {:groups=>{:id=>group_ids}}, :order => 'last_name, first_name')
  end

  def principals
   users.where(:user_group_assignments=>{:is_principal =>true})
  end

  def to_s
    title
  end

  def id_with_prefix
    id.to_s
  end
end
