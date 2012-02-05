When /^I add a team note$/ do
  click_link "Add Note"
  step "I fill in the note and save"
end

Then /^I should see the note on the student profile page$/ do
  step "I should be at the student profile page"
  page.should have_css('#student_profile img[alt="Note"]')
  page.should have_content("This is my team note")
end

Given /^there is a comment not by me$/ do
  other_user = Factory(:user, :district => cucumber_district)
  @student_comment = Factory(:student_comment, :student => cucumber_student, :user => other_user)
end

When /^I try to edit the comment anyway$/ do
  visit edit_student_student_comment_url(cucumber_student, @student_comment)
end



Then /^it should not work$/ do
  page.should have_content("Record not found")
end


When /^I follow Delete(?: within "([^"]*)")?$/ do |selector|
  with_scope(selector) do
    b=locate(:xpath, "//a[contains(.,'Delete')]")
    page.driver.delete  b[:href].to_s
  end
  step 'I follow "redirected"' if page.has_content? 'redirected'
end



When /^I try to delete the comment anyway$/ do
  page.driver.delete  student_student_comment_url(cucumber_student,@student_comment)
  step 'I follow "redirected"'
end

Given /^there is a comment by me$/ do
 @student_comemnt = Factory(:student_comment, :student => cucumber_student, :user => cucumber_user)
end

Then /^I should not see my comment$/ do
  page.should_not have_content("This is my team note")
  page.should_not have_css('#student_profile img[alt="Note"]')
end

When /^I edit the comment$/ do
  click_link "Edit"
  step "I fill in the note and save"
end

When /^I fill in the note and save$/ do
  fill_in "Note", :with => "This is my team note"
  click_button "Save"
end

