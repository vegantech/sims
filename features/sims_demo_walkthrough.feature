Feature: Sims Demo Walkthrough
  In order to show a demo works
  
  Scenario: Run Demo with oneschool
    Given load demo data 
    And I go to the home page
    And I fill in "Login" with "oneschool"
    And I fill in "Password" with "oneschool"
    Then I press "Login"
    And I should see "Logout"
    Then I follow "School Selection"
    And I should see "Alpha Elementary"
    Then I press "Choose School"
    Then I press "Search for Students"
    And I should see "Grader, Alpha_First"
    And I should see "Grader, Alpha_Third"
    Then I press "select for problem solving"
    And I should see "Student 1 of 2"
    Then I follow "Next"
    And I should see "Student 2 of 2"
    Then I follow "Create Custom Flag"
    And I fill in "custom_flag_reason" with "test reason from cucumber"
    And I select "Math" from "Category"
    Then I press "Save Custom Flag"
    Then I should see "Math- \ntest reason from cucumber"
    #can't remove yet, doesn't work without javascript
    Then I follow "Assign New Intervention"
    Then I select "Learning" from "goal_definition_id"
    Then I press "Choose Goal"
    Then I select "Math" from "objective_definition_id"
    Then I press "Choose Objective"
    Then I select "Algebra difficulty" from "intervention_cluster_id"
    Then I press "Choose Category"
    Then I select "Algebra two" from "intervention_definition_id"
    Then I press "Choose Intervention"
    #change some options here?
    Then I press "Create"

  Scenario: Alphaprin
    Given load demo data 
    And I go to the home page
    And I fill in "Login" with "alphaprin"
    And I fill in "Password" with "alphaprin"
    Then I press "Login"
    And I should see "Logout"
    Then I follow "School Selection"
    And I should see "Alpha Elementary"
    Then I press "Choose School"
    And I should see select box with id of "search_criteria_grade" and contains ["*", "1", "3","6"]
    And I should see select box with id of "search_criteria_user_id" and contains ["Filter by Group Member","1First. oneschool"]
    And I should see select box with id of "search_criteria_group_id" and contains ["Filter by Group", "Homeroom-- Oneschool", "Homeroom where oneschool is not a member"]
    Then I press "Search for Students"
    And I should see "Grader, Alpha_First"
    And I should see "Grader, Alpha_Third"

  Scenario alphagradethree
    Given load demo data 
    And I go to the home page
    And I fill in "Login" with "alphagradethree"
    And I fill in "Password" with "alphagradethree"
    Then I press "Login"
    Then I follow "School Selection"
    And I should see "Alpha Elementary"
    Then I press "Choose School"
#    And I should see select box with id of "search_criteria_grade" and contains ["3"]
#    And I should see select box with id of "search_criteria_user_id" and contains ["Filter by Group Member","1First. oneschool"]
#    And I should see select box with id of "search_criteria_group_id" and contains ["Filter by Group", "Homeroom-- Oneschool", "Homeroom where oneschool is not a member"]
#    Then I press "Search for Students"
#    And I should see "Grader, Alpha_First"
#    And I should see "Grader, Alpha_Third"

       
    

