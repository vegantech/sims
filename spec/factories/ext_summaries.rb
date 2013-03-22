# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ext_summary do
    streetAddress  {"123 Training Blvd Apt #{student.first_name[0..1]}"}
    cityStateZip  "Madison, WI 53704"
    HomeLanguage  "English"
    mealstatus  "F"
    englishProficiency  7
    specialEdStatus  "N"
    singleParent  false
    raceEthnicity  "W"
    suspensions_in  0
    suspensions_out  0
    years_in_district  7
    school_changes  2
    years_at_current_school  4
    previous_school_name  "Previous Elementary"
    current_attendance_rate  94.14
    previous_attendance_rate  94.58
    esl  false
    tardies  3
    student
   end
end
