# == Schema Information
# Schema version: 20101101011500
#
# Table name: user_school_assignments
#
#  id         :integer(4)      not null, primary key
#  school_id  :integer(4)
#  user_id    :integer(4)
#  admin      :boolean(1)
#  created_at :datetime
#  updated_at :datetime
#

class UserSchoolAssignment < ActiveRecord::Base
  belongs_to :school
  belongs_to :user

  # Need to be able to create these before assigning them to a parent...
  # validates_presence_of :school_id
  # validates_presence_of :user_id

  scope :admin, where(:admin => true)
  scope :non_admin, where(:admin => false)
  scope :school_id, select("school_id")
  after_save :create_all_students
  after_destroy :remove_special_user_groups

  def all_students
    !!user.special_user_groups.find_by_school_id_and_grade(school_id, nil) if user
  end

  def all_students=(val)
    id_will_change!
    if [true, "true", 1, "1"].include? val
      @all_students=true

    elsif [false,"false",0,"0"].include? val
      @all_students=false
    end

  end

  private
  def remove_special_user_groups
    SpecialUserGroup.delete_all("user_id = #{user_id} and school_id = #{school_id}")
  end

  def create_all_students
    if @all_students
      user.special_user_groups.find_or_create_by_school_id_and_grade(school_id,nil)
    elsif @all_students ==false
      user.special_user_groups.find_all_by_school_id_and_grade(school_id, nil).each(&:destroy)
    end
  end

end
