# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ext_sibling do
     first_name  "Brother"
    last_name  {student.last_name}
    student_number  "123456"
    age  12
    grade  "07"
    school_name  "Example Middle"
   end
end
