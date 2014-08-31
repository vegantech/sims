Feature: Search Page
  In order to pick students to manage
  A SIMS user
  Should be able to find students using search criteria

	Background: 
		Given clear login dropdowns

  Scenario: Search by grade *
    Given school "Glenn Stephens"
		And student "First" "Grader" in grade 1 at "Glenn Stephens"
		And student "Second" "Grader" in grade 2 at "Glenn Stephens"
		And group "My Group" for school "Glenn Stephens" with students ['First Grader', 'Second Grader']
		And I have access to "My Group"
		And I start at the the school selection page
#		And I select "Glenn Stephens" from "school_id"
#		And I press "Choose School"
		# And I start at the the search page

    # When I select "*" from "students_grade"
    When I select "*" from "Grade"
		And I press "Search for Students"

		Then I should see "2 students selected"
		And I should see "Grader, First"
		And I should see "Grader, Second"

  Scenario: Search by First Grade
    Given school "Glenn Stephens"
		And student "First" "Grader" in grade 1 at "Glenn Stephens"
    And student "First" "Grader" also in grade LH803 at "Glenn Stephens" in 2007
		And student "Second" "Grader" in grade 2 at "Glenn Stephens"
		And group "My Group" for school "Glenn Stephens" with students ['First Grader', 'Second Grader']
		And I have access to "My Group"
		And I start at the the school selection page
#		And I select "Glenn Stephens" from "school_id"
#		And I press "Choose School"
		# And I start at the the search page

    When I select "1" from "Grade"
		And I press "Search for Students"

		Then I should see "1 student selected"
		And I should see "Grader, First"
		And I should not see "Grader, Second"
