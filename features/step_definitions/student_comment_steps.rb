When /^I add a team note$/ do
  click_link "Add Note"
  fill_in "note", :with => "This is my team note"
  click_button "Save"
end

Then /^I should see the note on the student profile page$/ do
  step "I should be at the student profile page"
  response.should have_selector('#student_profile img[alt="Note"]')
  response.should contain("This is my team note")
end

Given /^there is a comment not by me$/ do
  other_user = Factory(:user, :district => cucumber_district)
  @student_comment = Factory(:student_comment, :student => cucumber_student, :user => other_user)
end

When /^I try to edit the comment anyway$/ do
  visit edit_student_student_comment_url(cucumber_student, @student_comment)
end



Then /^it should not work$/ do
  response.should contain("Record not found")
end


When /^I follow Delete$/ do
    click_link 'Delete', :method => :delete
end


When /^I try to delete the comment anyway$/ do
  visit student_student_comment_url(cucumber_student,@student_comment),  :delete
end

Given /^there is a comment by me$/ do
 @student_comemnt = Factory(:student_comment, :student => cucumber_student, :user => cucumber_user)
end

Then /^I should not see my comment$/ do
  response.should_not contain("This is my team note")
  response.should_not have_selector('#student_profile img[alt="Note"]')
end

When /^I edit the comment$/ do
  click_link "Edit"
  fill_in "note", :with => "This is my team note"
  click_button "Save"
end

