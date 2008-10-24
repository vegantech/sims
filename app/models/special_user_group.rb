class SpecialUserGroup < ActiveRecord::Base
  belongs_to :user
  belongs_to :district
  belongs_to :school

  #other fields, grade, type, is_principal
  #temporary list of types for now there's also a grade field
  TYPES=%w(all_students_in_district, all_schools_in_district, all_students_in_school)

end
