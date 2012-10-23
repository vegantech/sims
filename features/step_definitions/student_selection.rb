Given /^(\d+) students$/ do |num|
  minimum_for_profile
  (-1 + num.to_i).times {s=Factory(:student, :district => cucumber_student.district); Factory(:enrollment, :student => s, :school => cucumber_school)}
end

Given /^I am at the student selection page$/ do
  visit root_path
  fill_in "Login", :with =>cucumber_user.username
  fill_in 'Password', :with => cucumber_user.username
  click_button 'Login'
  click_button 'Search for Students'
end

Then /^all students should be selected$/ do
  page.all('tbody [type="checkbox"]').each {|c| c['checked'].should be_true}
end

Then /^no students should be selected$/ do
  page.all('tbody [type="checkbox"]').each {|c| c['checked'].should be_false}
end
