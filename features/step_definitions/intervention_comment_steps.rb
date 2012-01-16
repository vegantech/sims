Given /^there is an intervention by another user$/ do
  @intervention = Factory(:intervention, :student => cucumber_student)
end

When /^I edit that intervention and add a comment$/ do
  click_link("Edit/Add Comment")
  fill_in(/comment/, :with => "Made by me")
  click_button("Save")
end

When /^view that intervention again$/ do
  click_link("Edit/Add Comment")
end

Then /^I should see the comment was made by me$/ do
  response.should contain("Made by me")
  response.should contain("by #{cucumber_user.fullname}")
end


