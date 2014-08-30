When /^I select a blank year$/ do
  b=find(:css, 'option[value=""]').select_option
end

Then /^page should have a "([^"]*)" button$/ do |button_name|
    page.should have_button button_name
end

Given(/^student "(.*?)" "(.*?)" also in grade LH(\d+) at "(.*?)" in (\d+)$/) do |first, last, grade, school, year|
  stu = Student.find_by_first_name_and_last_name first, last
  school = School.find_by_name school
  stu.enrollments.create! school: school, grade: grade, end_year: year
end



