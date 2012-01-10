When /^I add a team note$/ do
  click_link "Add Note"
  fill_in "note", :with => "This is my team note"
  click_button "Save"
end

Then /^I should see the note on the student profile page$/ do
  step "I should be at the student profile page"
  response.should have_selector('img[alt="Note"]')
  response.should contain("This is my team note")
end

