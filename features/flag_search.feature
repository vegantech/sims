Feature: Search By Intervention Flags
  In order to pick students to manage
  A SIMS user
  Should be able to find students by intervention flags
  
  Scenario: Search by All Students
    Given school "Glenn Stephens"
		And student "Eric" "Aagard" in grade 1 at "Glenn Stephens"
		And student "Mike" "Baumeister" in grade 2 at "Glenn Stephens"
		And I am on the "school selection" page
		And I select "Glenn Stephens" from "school_id"
		And I press "Choose School"
		And I choose "List all students"

		When I press "Search for Students"

		Then I should see "2 students selected"
		And I should see "Aagard, Eric"
		And I should see "Baumeister, Mike"
