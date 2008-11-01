Feature: Search By Student Last Name
  In order to pick students to manage
  A SIMS user
  Should be able to find students by last name
  
  Scenario: Search by First Grade
    Given school "Glenn Stephens"
		And student "Eric" "Aagard" in grade 1 at "Glenn Stephens"
		And student "Mike" "Baumeister" in grade 2 at "Glenn Stephens"
		And I am on the school selection page
		And I select "Glenn Stephens" from "school_id"
		And I press "Choose School"
		# And I am on the search page

		When I fill in "Last Name" with "Aagard"
		And I press "Search for Students"

		Then I should see "1 student selected"
		And I should see "Aagard, Eric"
		And I should not see "Baumeister, Mike"
