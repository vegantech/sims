Feature: Sims Demo Walkthrough
  In order to show a demo works
  
  Scenario: Run Demo
    Given load demo data 
    And I go to the home page
    And I fill in "Login" with "oneschool"
    And I fill in "Password" with "oneschool"
    And I press "Login"
    And I should see "Logout"
    And I follow "School Selection"
    And I should see "Alpha Elementary"
    And I press "Choose School"
    And I press "Search for Students"
    And I should see "Grader, Alpha_First"
    And I should see "Grader, Alpha_Third"
    And I should click js "all"
    And I press "select for problem solving"
    And I should see "Student 1 of 2"
    And I follow ">>"
    And I should see "Student 2 of 2"
