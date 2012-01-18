class PersonalGroup < ActiveRecord::Base
  belongs_to :user
  belongs_to :school
  has_and_belongs_to_many :students

  DESCRIPTION="Allows you to manage your own custom groups.  These will appear at the top of the group dropdown on the search screen."
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => [:user_id, :school_id]


  named_scope :by_school, lambda { |school| {:conditions=>{:school_id=>school}, :order =>:name}}
  named_scope :by_grade, lambda { |grade| {:joins => {:students => :enrollments}, :conditions=>["enrollments.school_id = personal_groups.school_id and enrollments.grade = ?",grade]}}



  def title
    name
  end

  def id_with_prefix
    "pg#{id}"
  end

  def self.by_school_and_grade(school, grade=nil)
    #this needs to limit to grade
    g=by_school(school)
    g=g.by_grade(grade) if grade
    g
  end
end
