class PersonalGroup < ActiveRecord::Base
  belongs_to :user
  belongs_to :school
  has_and_belongs_to_many :students

  DESCRIPTION = "Allows you to manage your own custom groups.  These will appear at the top of the group dropdown on the search screen."
  validates_presence_of :name
  validates_uniqueness_of :name, scope: [:user_id, :school_id]
  ID_MATCH = /^pg/i
  TITLE_MATCH = /^pg- /i


  scope :by_school, lambda { |school| where(school_id: school).order(:name)}
  scope :by_grade, lambda { |grade| where(["exists(select 1 from enrollments inner join personal_groups_students pgs on enrollments.student_id = pgs.student_id
  where enrollments.school_id = personal_groups.school_id
  and enrollments.student_id = pgs.student_id and pgs.personal_group_id = personal_groups.id and grade = ? ) ",grade])}


  def title
   "pg- #{name}"
  end

  def id_with_prefix
    "pg#{id}"
  end

  def self.by_school_and_grade(school, grade = nil)
    #this needs to limit to grade
    g = by_school(school)
    g = g.by_grade(grade) if grade
    g
  end
end
