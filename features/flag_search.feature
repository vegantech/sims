Feature: Search By Intervention Flags
  In order to pick students to manage
  A SIMS user
  Should be able to find students by intervention flags
  
  Scenario: List all students
    Given school "Glenn Stephens"
		And student "Eric" "Aagard" in grade 1 at "Glenn Stephens" with "attendance" flag
		And student "Mike" "Baumeister" in grade 2 at "Glenn Stephens"
		And I am on the "school selection" page
		And I select "Glenn Stephens" from "school_id"
		And I press "Choose School"
		And I choose "List all students"

		When I press "Search for Students"

		Then I should see "2 students selected"
		And I should see "Aagard, Eric"
		And I should see "Baumeister, Mike"

	Scenario: List only students flagged for intervention A
		Given school "Glenn Stephens"
		And student "Eric" "Aagard" in grade 1 at "Glenn Stephens" with "attendance" flag
		And student "Mike" "Baumeister" in grade 2 at "Glenn Stephens"
		And I am on the "school selection" page
		And I select "Glenn Stephens" from "school_id"
		And I press "Choose School"
		And I choose "List only students flagged for intervention"
		And I check "flag_attendance"

		When I press "Search for Students"

		Then I should see "1 student selected"
		And I should see "Aagard, Eric"
		And I should not see "Baumeister, Mike"

  Scenario: List  students flagged for intervention A or M
    Given school "Ridgewood"
    And student "Adam" "Partridge" in grade 2 at "Ridgewood" with "attendance" flag
    And student "Andy" "Dudley" in grade 3 at "Ridgewood"
    And student "Craig" "Acomb" in grade 4 at "Ridgewood" with "math" flag
		And student "Different" "Flag" in grade 2 at "Ridgewood" with "suspension" flag
    And I am on the "school selection" page
    And I select "Ridgewood" from "school_id"
    And I press "Choose School"
    And I choose "List only students flagged for intervention"
    And I check "flag_attendance"
		And I check "flag_math"

    When I press "Search for Students"

    Then I should see "2 students selected"
    And I should see "Partridge, Adam"
    And I should not see "Dudley, Andy"
		And I should see "Acomb, Craig"
		And I should not see "Flag, Different"

  Scenario: User does not select intervention flags
    Given school "Ridgewood"
    And student "Adam" "Partridge" in grade 2 at "Ridgewood" with "attendance" flag
    And student "Andy" "Dudley" in grade 3 at "Ridgewood"
    And student "Craig" "Acomb" in grade 4 at "Ridgewood" with "math" flag
		And student "Different" "Flag" in grade 2 at "Ridgewood" with "suspension" flag
    And I am on the "school selection" page
    And I select "Ridgewood" from "school_id"
    And I press "Choose School"
    And I choose "List only students flagged for intervention"

    When I press "Search for Students"

    Then I should see "0 students selected"
    And I should not see "Partridge, Adam"
    And I should not see "Dudley, Andy"
		And I should not see "Acomb, Craig"
		And I should not see "Flag, Different"