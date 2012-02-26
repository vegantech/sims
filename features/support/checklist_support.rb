def cucumber_district
  #switch out default district with this
  @cucumber_district ||= District.delete_all && Factory(:district, :name => "Cucumber")
end

def cucumber_user
  @cucumber_user ||= Factory(:user, :username => "cucumber_user", :district => cucumber_district, :first_name => "Cucumber", :all_students_in_district => '1', :roles => ['regular_user'])
end

def cucumber_student
  @cucumber_student ||= Factory(:student, :first_name => "Cucumber", :last_name => "Student", :district => cucumber_district)
end

def cucumber_school
  @cucumber_school ||= Factory(:school, :district => cucumber_district, :name => "Cucumber School")
end


def cucumber_enrollment
  @enrollment ||= Factory(:enrollment, :school => cucumber_school, :student => cucumber_student, :grade => "09", :end_year => "2010")
end

def minimum_for_profile
  cucumber_enrollment
  cucumber_user
end

