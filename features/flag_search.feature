Feature: Search By Intervention Flags
  In order to pick students to manage
  A SIMS user
  Should be able to find students by intervention flags
  
	Background: 
		Given clear login dropdowns
  
	Scenario: List all students
    Given school "Glenn Stephens"
		And student "Eric" "Aagard" in grade 1 at "Glenn Stephens" with "attendance" flag
		And student "Mike" "Baumeister" in grade 2 at "Glenn Stephens"
    And group "My Group" for school "Glenn Stephens" with students ["Eric Aagard", "Mike Baumeister"]
    And I have access to "My Group"
		And I am on the school selection page
#		And I select "Glenn Stephens" from "school_id"
#		And I press "Choose School"
		And I choose "List all students"

		When I press "Search for Students"

		Then I should see "2 students selected"
		And I should see "Aagard, Eric"
		And I should see "Baumeister, Mike"

  Scenario: List only students with ignore flags
    Given school "Glenn Stephens"
		And student "Eric" "Aagard" in grade 1 at "Glenn Stephens" with "attendance" flag
		And student "Mike" "Baumeister" in grade 2 at "Glenn Stephens"
		And student "Sally" "Cart" in grade 2 at "Glenn Stephens" with ignore_flag for "math" with reason "Ignore this math flag"
    And group "My Group" for school "Glenn Stephens" with students ["Eric Aagard", "Mike Baumeister", "Sally Cart"]
    And I have access to "My Group"
		And I am on the school selection page
#		And I select "Glenn Stephens" from "school_id"
#		And I press "Choose School"
		And I choose "List only students flagged for intervention"
    And I check "flag_ignored"
		When I press "Search for Students"
		Then I should see "1 student selected"
		And I should see "Cart, Sally"

  Scenario: List only students with custom flags
    Given school "Glenn Stephens"
		And student "Eric" "Aagard" in grade 1 at "Glenn Stephens" with "attendance" flag
		And student "Mike" "Baumeister" in grade 2 at "Glenn Stephens"
		And student "Sally" "Wood" in grade 2 at "Glenn Stephens" with custom_flag for "attendance" with reason "Always skips homeroom"
    And group "My Group" for school "Glenn Stephens" with students ["Eric Aagard", "Mike Baumeister", "Sally Wood"]
    And I have access to "My Group"
		And I am on the school selection page
#		And I select "Glenn Stephens" from "school_id"
#		And I press "Choose School"
		And I choose "List only students flagged for intervention"
    And I check "flag_custom"
		When I press "Search for Students"
		Then I should see "1 student selected"
		And I should see "Wood, Sally"

  Scenario: Exclude students with only ignored flags
    Given school "Glenn Stephens"
		And student "Eric" "Aagard" in grade 1 at "Glenn Stephens" with "attendance" flag
		And student "Mike" "Baumeister" in grade 2 at "Glenn Stephens"
		And student "Sally" "Cart" in grade 2 at "Glenn Stephens" with ignore_flag for "math" with reason "Ignore this math flag"
    And student "Has" "Both" in grade 3 at "Glenn Stephens" with "attendance" flag and ignore_flag for "attendance" with reason "Actually here"
    And student "Has" "More" in grade 4 at "Glenn Stephens" with "math" flag and ignore_flag for "attendance" with reason "Actually here"
    And group "My Group" for school "Glenn Stephens" with students ["Eric Aagard", "Mike Baumeister", "Sally Cart", "Has Both", "Has More"]
    And I have access to "My Group"
		And I am on the school selection page
#		And I select "Glenn Stephens" from "school_id"
#		And I press "Choose School"
		And I choose "List only students flagged for intervention"
		When I press "Search for Students"
    And I should see "More, Has"
    And I should see "Aagard, Eric"
		And I should see "2 students selected"


	Scenario: List only students flagged for intervention A
		Given school "Glenn Stephens"
		And student "Eric" "Aagard" in grade 1 at "Glenn Stephens" with "attendance" flag
		And student "Mike" "Baumeister" in grade 2 at "Glenn Stephens"
		And group "Whatta Group" for school "Glenn Stephens" with students ['Eric Aagard', 'Mike Baumeister']
		And I have access to "Whatta Group"
		And I am on the school selection page
#		And I select "Glenn Stephens" from "school_id"
#		And I press "Choose School"
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
		And group "Some Kinda Group" for school "Ridgewood" with students ['Adam Partridge', 'Andy Dudley', 'Craig Acomb', 'Different Flag']
		And I have access to "Some Kinda Group"
    And I am on the school selection page
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
		And group "Some Kinda Group" for school "Ridgewood" with students ['Adam Partridge', 'Andy Dudley', 'Craig Acomb', 'Different Flag']
		And I have access to "Some Kinda Group"
    And I am on the school selection page
    And I select "Ridgewood" from "school_id"
    And I press "Choose School"
    And I choose "List only students flagged for intervention"

    When I press "Search for Students"

    Then I should see "3 students selected"
    And I should see "Partridge, Adam"
    And I should not see "Dudley, Andy"
    And I should see "Acomb, Craig"
    And I should see "Flag, Different"
