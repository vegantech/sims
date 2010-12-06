Feature: School Selection
  In order to constrain student selection by school
  A SIMS user
  Should be able to select from the available schools

  Scenario: School Choices Displayed
    Given school "Default School"
		And school "Velma Hamilton"

    When I start at the school selection page

		Then I should see select box with id of "school_id" and contains ["Default School", "Velma Hamilton"]

	Scenario: Select Orchard Ridge
		Given school "Orchard Ridge"
		And school "Ridge View"
    And group "My Group" for school "Orchard Ridge"
    And I have access to "My Group"
		And I start at the school selection page

		When I select "Orchard Ridge" from "school_id"
		And I press "Choose School"
                And I should see "User doesn't have access to any students at Orchard Ridge"


	Scenario: Select Ridge View
		Given school "Orchard Ridge"
		And school "Ridge View"
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
    And page should contain "Choose School"

  Scenario: Auto Select School
    Given school "Default School"
		#And school "Velma Hamilton"

    When I start at the school selection page
    And show me the page
    Then I should see "User doesn't have access to any students at Default School"


