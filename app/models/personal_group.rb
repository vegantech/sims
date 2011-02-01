class PersonalGroup < ActiveRecord::Base
  belongs_to :user
  belongs_to :school
  has_and_belongs_to_many :students

  #this allows me to use id
  FAKE_GROUP=OpenStruct.dup
  FAKE_GROUP.__send__(:define_method, :id) { @table[:id] || self.object_id }

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => [:user_id, :school_id]


  named_scope :by_school, lambda { |school| {:conditions=>{:school_id=>school}, :order =>:name}}
  named_scope :by_grade, lambda { |grade| {:conditions=>["exists(select id from enrollments inner join personal_groups_students on enrollments.student_id = personal_groups_students.student_id where enrollments.school_id = personal_groups.school_id 
  and enrollments.student_id = personal_groups_students.student_id and personal_groups_students.personal_group_id = personal_groups.id and grade = ? ) ",grade] }}

  def self.by_school_and_grade(school, grade=nil)
    #this needs to limit to grade
    g=by_school(school.id)
    g=g.by_grade(grade) if grade
    g.collect{|pg| FAKE_GROUP.new(:title =>"PG- #{pg.name}",:id =>"pg#{pg.id}")}
  end
end
