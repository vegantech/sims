# == Schema Information
# Schema version: 20101101011500
#
# Table name: special_user_groups
#
#  id           :integer(4)      not null, primary key
#  user_id      :integer(4)
#  school_id    :integer(4)
#  grade        :string(255)
#  is_principal :boolean(1)
#  created_at   :datetime
#  updated_at   :datetime
#

class SpecialUserGroup < ActiveRecord::Base
  belongs_to :user
  belongs_to :school

  validates_presence_of :user_id,:school_id
  validates_uniqueness_of :user_id, :scope=>[:grade,:school_id] , :message => "-- Remove the user first."


  scope :principal,where(:is_principal=>true)
  scope :all_students_in_school ,lambda { |*args| where(["grade is null and school_id = ?", args.first])}

  def self.all_students_in_school?(school)
    all_students_in_school(school).count > 0
  end

  def self.schools
    sql = select('distinct school_id').to_sql
    school_ids = connection.select_values sql
    School.find_all_by_id school_ids
  end

  def self.grades_for_school(school)
    sql= select('distinct grade').where(["grade is not null and school_id = ?", school]).to_sql
    connection.select_values(sql)
  end

  def to_i
    #fixes ticket 152
    1
  end

  def title
    "All Students in #{grade ? 'Grade: '+grade.to_s : 'School'}"
  end

  def to_param
    if new_record?
      title.parameterize
    else
      super
    end
  end

  def self.virtual_groups(grades)
    ([nil] | Array(grades)).collect{|g| new(:grade => g)}
  end
end

