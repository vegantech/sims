Feature: School Selection
  In order to constrain student selection by school
  A SIMS user
  Should be able to select from the available schools

	Background:
		Given clear login dropdowns
  
  Scenario: School Choices Displayed
    Given school "Glenn Stephens"
		And school "Velma Hamilton"

    When I start at the school selection page

		Then I should see select box with id of "school_id" and contains ["Glenn Stephens", "Velma Hamilton"]

	Scenario: Select Empty School
		Given school "Empty School"
		And school "Ridge View"
    And group "My Group" for school "Empty School"
    And I have access to "My Group"
		And I start at the school selection page

		When I select "Empty School" from "school_id"
		And I press "Choose School"
    And I should see "Empty School has no students enrolled."


	Scenario: Select Ridge View
		Given school "Orchard Ridge"
		And school "Ridge View"
    And group "Maroon Team" for school "Ridge View" with student "Harold Yerbie"
    And group "My Group" for school "Ridge View"
    And I have access to "My Group"
		And I start at the school selection page

		When I select "Ridge View" from "school_id"
		And I press "Choose School"

                And I should see "User doesn't have access to any students at Ridge View"

  Scenario: User With No Groups Sees Flash Message
    Given school "East High"
    And group "Orange Team" for school "East High" with student "Alfie Orange"
    And group "Maroon Team" for school "East High" with student "Harold Yerbie"
		And I start at the school selection page

		When I select "East High" from "school_id"
		And I press "Choose School"

    Then I should see "User doesn't have access to any students at East High"
    And page should have a "Choose School" button

  Scenario: Auto Select School
		Given clear login dropdowns
    Given school "Glenn Stephens"
		#And school "Velma Hamilton"

    When I start at the school selection page
    Then I should see "Glenn Stephens has no students enrolled"


