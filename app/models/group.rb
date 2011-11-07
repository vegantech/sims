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
  belongs_to :school
  has_and_belongs_to_many :students
  has_many :user_group_assignments
  has_many :users, :through=>:user_group_assignments
  validates_presence_of :title, :school_id
  validates_uniqueness_of :title, :scope=>:school_id

  named_scope :by_school, lambda { |school| {:conditions=>{:school_id=>school}}}
  named_scope :by_grade, lambda { |grade| {:conditions=>["exists(select id from enrollments inner join groups_students on enrollments.student_id = groups_students.student_id where enrollments.school_id = groups.school_id 
  and enrollments.student_id = groups_students.student_id and groups_students.group_id = groups.id and grade = ? ) ",grade],
  }}
  def self.members
    #TODO tested, but it is ugly and should be refactored
    group_ids=find(:all,:select=>"groups.id")
    User.find(:all,:joins => :groups ,:conditions=> {:groups=>{:id=>group_ids}}, :order => 'last_name, first_name').uniq
  end

  def principals
   users.find(:all, :include=>:user_group_assignments, :conditions => ["user_group_assignments.is_principal = ?",true])
  end

  def self.paged_by_title(title="", page="1")
    paginate :per_page => 25, :page => page, 
      :conditions=> ['title like ?', "%#{title}%"],
      :order => 'title'
  end
end
