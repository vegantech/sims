Feature: Search By Student Last Name
  In order to pick students to manage
  A SIMS user
  Should be able to find students by enrollment year

  Background:
		Given clear login dropdowns
    Given no other schools

  Scenario: Search by year
    Given school "Glenn Stephens"
		And student "Sally" "Carpenter" in grade 1 at "Glenn Stephens"
		And student "Eric" "Aagard" in grade 1 at "Glenn Stephens" in 2008
    And student "Eric" "Aagard" also in grade LH803 at "Glenn Stephens" in 2007
		And student "Mike" "Baumeister" in grade 2 at "Glenn Stephens" in 2009
		And group "My Group" for school "Glenn Stephens" with students ['Eric Aagard', 'Mike Baumeister', 'Sally Carpenter']
		And I have access to "My Group"
		And I start at the school selection page
#		And I select "Glenn Stephens" from "school_id"
#		And I press "Choose School"
		# And I start at the search page

    Then I should see select box with id of "search_criteria_year" and contains ['All', '', '2008', '2009']
    When I select "All" from "Year"
		When I press "Search for Students"
		Then I should see "4 students selected"

    When I follow "Student Search"
    And I select "2008" from "Year"
    And I press "Search for Students"
		Then I should see "1 student selected"
		And I should see "Aagard, Eric"

    When I follow "Student Search"
    And I select "2009" from "Year"
    And I press "Search for Students"
		Then I should see "1 student selected"
		And I should see "Baumeister, Mike"

    When I follow "Student Search"
    And I select a blank year
    And I press "Search for Students"
		Then I should see "1 student selected"
    And I should see "Carpenter, Sally"




  Scenario: Other Enrollments
    Given school "Glenn Stephens"
		And student "Eric" "Aagard" in grade 1 at "Glenn Stephens" in 2028
		And group "My Group" for school "Glenn Stephens" with students ['Eric Aagard']
		And I have access to "My Group"
		And I start at the school selection page
#		And I select "Glenn Stephens" from "school_id"
#		When I press "Choose School"
		# And I start at the search page
    Then I should see select box with id of "search_criteria_year" and contains ['All', '2028']
