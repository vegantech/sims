Feature: Search Page
  In order to pick students to manage
  A SIMS user
  Should be able to find students using search criteria
  
  Scenario: Search by First Grade
    Given school "Glenn Stephens"
		And student "First" "Grader" in grade 1 at "Glenn Stephens"
		And student "Second" "Grader" in grade 2 at "Glenn Stephens"
		And I am on the "school selection" page
		And I select "Glenn Stephens" from "school_id"
		And I press "Choose School"
		# And I am on the "search" page

    When I select "*" from "students_grade"
		And I press "Search for Students"

		Then I should see "2 students selected"
		And I should see "Grader, First"
		And I should see "Grader, Second"
