Feature: Search Page
  In order to pick students to manage
  A SIMS user
  Should be able to find students using search criteria
  
  Scenario: Search by All Grades
    Given student "First" "Grader" in grade 1
		And student "Second" "Grader" in grade 2
		And I am on the "search" page

    When I select "*" from "students_grade"
		And I press "Search for Students"

		Then I should see "2 students selected"
		And I should see "First Grader"
		And I should see "Second Grader"
