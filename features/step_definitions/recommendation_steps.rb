Given /^Recommendations enabled$/ do
  FactoryGirl.create :basic_recommendation_definition
  Tier.create! title: "Tier", district: cucumber_district
end

When /^I create a valid recommendation that does not increase the tier$/ do
  click_link("Complete Conclusion and Recommendation")
  choose("The student is not making progress; choose new interventions from the current level; continue to monitor progress.")
  click_button("Submit")
end

Then /^I should see a summary of that recommendation$/ do
  page.should have_content("Recommendation completed by Cucumber Last_Name")
end

