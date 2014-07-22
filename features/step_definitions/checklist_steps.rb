Given /^I am at the student profile page$/ do
  minimum_for_profile
  @school ||= Factory(:school, district: cucumber_district)
  @enrollment ||= Factory(:enrollment, school: @school, student: @student)
  visit student_url(cucumber_student)
  fill_in "Login", with: cucumber_user.username
  fill_in 'Password', with: cucumber_user.username
  click_button 'Login'
end

Given /^I am at the student search page$/ do
  minimum_for_profile
  @school ||= Factory(:school, district: cucumber_district)
  @enrollment ||= Factory(:enrollment, school: @school, student: @student)
  visit school_student_search_url(@school)
  fill_in "Login", with: cucumber_user.username
  fill_in 'Password', with: cucumber_user.username
  click_button 'Login'
end

When /^I try to view an invalid checklist$/ do
    visit checklist_url("invalid")
end

Then /^I should be at the student profile page$/ do
  URI.parse(current_url).path.should == student_path(cucumber_student)
end

Then /^I should see a notice for "([^"]*)"$/ do |regexp|
  with_scope("flash_notice") do
    page.should have_content(regexp)
  end
end

Given /^a completed checklist$/ do
  @checklist_definition ||= Factory(:checklist_definition, district: cucumber_district)
  @tier ||= Factory(:tier, district: cucumber_district)
  @checklist ||= Factory(:checklist, checklist_definition: @checklist_definition, tier: @tier, teacher: cucumber_user, student: cucumber_student)
end

When /^I view the checklist$/ do
  with_scope(".profile_page #checklists") do
    click_link "view"
  end
end

Then /^I should see the completed checklist$/ do
  URI.parse(current_url).path.should == checklist_path(@checklist)
    pending # express the regexp above with the code you wish you had
end

When /^I edit the checklist$/ do
  with_scope(".profile_page #checklists") do
    click_link "edit"
  end
  #change a scale, leave one alone, pick a new one, edit a comment, clear out a comment, add a new comment
  click_button "Submit"
end
