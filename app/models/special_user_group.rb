# == Schema Information
# Schema version: 20101101011500
#
# Table name: special_user_groups
#
#  id           :integer(4)      not null, primary key
#  user_id      :integer(4)
#  district_id  :integer(4)
#  school_id    :integer(4)
#  grouptype    :integer(4)
#  grade        :string(255)
#  is_principal :boolean(1)
#  created_at   :datetime
#  updated_at   :datetime
#

class SpecialUserGroup < ActiveRecord::Base
  belongs_to :user
  belongs_to :district
  belongs_to :school

  #other fields, grade, grouptype, is_principal
  #temporary list of grouptypes for now there's also a grade field
  ALL_SCHOOLS_IN_DISTRICT=1  #not going to fully implement this yet
  ALL_STUDENTS_IN_DISTRICT =2
  ALL_STUDENTS_IN_SCHOOL = 3

  validates_presence_of :grouptype, :user_id
  validates_presence_of :district_id #, :if => lambda {|s| s.school_id.blank?}
  validates_presence_of :school_id, :if => lambda {|s| s.district_id.blank?}
  validates_uniqueness_of :user_id, :scope=>[:grade,:district_id,:school_id,:grouptype] , :message => "-- Remove the user first."
  attr_protected :district_id
  before_validation :assign_district_from_user


  scope :principal,where(:is_principal=>true)
  scope :all_schools_in_district ,where(:grouptype=>[ALL_SCHOOLS_IN_DISTRICT,ALL_STUDENTS_IN_DISTRICT])
  scope :all_students_in_school ,lambda { |*args| where(["grouptype=? or (grouptype = ? and grade is null and school_id = ?) ",ALL_STUDENTS_IN_DISTRICT, ALL_STUDENTS_IN_SCHOOL,  args.first])}
  scope :all_students_in_district, where(:grouptype=>ALL_STUDENTS_IN_DISTRICT)

  def self.all_students_in_school?(school)
    all_students_in_school(school).count > 0
  end

  def self.schools
    sql = select('distinct school_id').to_sql
    school_ids = connection.select_values sql
    School.find_all_by_id school_ids
  end

  def self.grades_for_school(school)
    sql= select('distinct grade').where(["grade is not null and grouptype = ? and school_id = ?", ALL_STUDENTS_IN_SCHOOL,school]).to_sql
    connection.select_values(sql)
  end

  def to_i
    #fixes ticket 152
    1
  end

  def self.trying_something
    finder_sql = select("school_id, user_id").joins(
      "left outer join user_school_assignments uga on uga.user_id = special_user_groups.user_id and uga.school_id = uga.school_id
      inner join users on special_user_groups.user_id = users.id and users.district_id = special_user_groups.district_id").group(
      "special_user_groups.school_id, special_user_groups.user_id").where(:grouptype => ALL_STUDENTS_IN_SCHOOL, 'uga.id' => nil).to_sql
  end
  def self.autoassign_user_school_assignments
    finder_sql = select( 'special_user_groups.school_id, special_user_groups.user_id').joins(
      "left outer join user_school_assignments uga on uga.user_id = special_user_groups.user_id and uga.school_id = special_user_groups.school_id
      inner join users on special_user_groups.user_id = users.id and users.district_id = special_user_groups.district_id").group(
      "special_user_groups.school_id, special_user_groups.user_id").where(:grouptype => ALL_STUDENTS_IN_SCHOOL, 'uga.id' => nil).to_sql
     query= "insert into user_school_assignments (school_id,user_id) #{finder_sql}"
     SpecialUserGroup.connection.update query
  end
  private
  def assign_district_from_user
    self.district_id = user.district_id if district_id.blank? && user.present?
  end
end

