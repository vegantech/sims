Given /^There is an IC Jump Student$/ do
  minimum_for_profile
  @school ||= Factory(:school, district: cucumber_district)
  @enrollment ||= Factory(:enrollment, school: @school, student: @student)
  cucumber_student.update_attribute(:district_student_id, "cucumber_student")
end

When /^I enter the ic jump to that student$/ do
  visit "/students/ic_jump?contextID=cucumber_student"
end

When /^I login$/ do
  fill_in "Login", with: cucumber_user.username
  fill_in 'Password', with: cucumber_user.username
  click_button 'Login'
end

Then /^I should have a student_id cookie$/ do
  visit current_url
  my_cookies = Capybara
    .current_session
    .driver
    .request
    .cookies
  my_cookies["selected_student"].should == cucumber_student.id.to_s
end



