# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ext_adult_contact do
    relationship  "Parent"
    guardian  true
    firstName  "Plato"
    lastName  {student.last_name}
    streetAddress  {"123 Training Blvd Apt #{student.first_name[0..1]}"}
    cityStateZip  "Madison, WI 53704"
    cellPhone  "(608)555-1212"
   end
end
