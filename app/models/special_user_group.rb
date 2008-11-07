# == Schema Information
# Schema version: 20081030035908
#
# Table name: special_user_groups
#
#  id           :integer         not null, primary key
#  user_id      :integer
#  district_id  :integer
#  school_id    :integer
#  grade        :string(255)
#  type         :string(255)
#  is_principal :boolean
#  created_at   :datetime
#  updated_at   :datetime
#

class SpecialUserGroup < ActiveRecord::Base
  belongs_to :user
  belongs_to :district
  belongs_to :school

  #other fields, grade, type, is_principal
  #temporary list of types for now there's also a grade field
  TYPES=%w(all_students_in_district, all_schools_in_district, all_students_in_school)

  named_scope :all_schools_in_district ,:conditions=>{:type=>"AllSchoolsInDistrict"}
  named_scope :all_students_in_school ,lambda { |*args| {:conditions=>["type=? or type = ? and grade is null and school_id = ?","AllSchoolsInDistrict","AllStudentsInSchool", args.first]}}


  def self.all_students_in_school?(school)
    !! find(:first,:conditions=>["type=? or type = ? and school_id = ?","AllSchoolsInDistrict","AllStudentsInSchool", school.id])
  end

end

class AllSchoolsInDistrict < SpecialUserGroup


end
