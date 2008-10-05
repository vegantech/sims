Feature: School Selection
  In order to constrain student selection by school
  A SIMS user
  Should be able to select from the available schools
  
  Scenario: School Choices Displayed
    Given school "Glenn Stephens"
		And school "Velma Hamilton"

    When I go to the school selection page

		Then I should see select box with "Glenn Stephens" and "Velma Hamilton"
