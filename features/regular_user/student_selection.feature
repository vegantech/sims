Feature: Student Selection
  In order to work with students
  A SIMS USER
  Should be able to choose which ones to work with

@javascript
  Scenario: Check all and none
		Given 4 students
		And I am at the student selection page
		When I follow "all"
		Then all students should be selected
		When I follow "none"
		Then no students should be selected

