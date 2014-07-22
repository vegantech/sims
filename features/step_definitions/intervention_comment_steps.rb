Given /^there is an intervention by another user$/ do
  @intervention = Factory(:intervention, student: cucumber_student)
end

When /^I edit that intervention and add a comment$/ do
  click_link("Edit/Add Comment")
  fill_in("Add new comment about the intervention plan and progress", with: "Made by me")
  click_button("Save")
end

When /^view that intervention again$/ do
  click_link("Edit/Add Comment")
end

Then /^I should see the comment was made by me$/ do
  page.should have_content("Made by me")
  page.should have_content("by #{cucumber_user.fullname}")
end


