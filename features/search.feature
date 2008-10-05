Feature: Search Page
  In order to pick students to manage
  A SIMS user
  Should be able to find students using search criteria
  
  Scenario: Search by Grade
    Given 1 student in grade 1
		And 1 student in grade 2
		And I am on the "search" page

    When I press "Search"

		Then I should see 1 student
