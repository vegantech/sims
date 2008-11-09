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
    And I should click js "all"
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
    And I should see select box with id of "search_criteria_user_id" and contains ["Filter by Group Member","1First. oneschool","2Second. twoschools"]
    And I should see select box with id of "search_criteria_group_id" and contains ["Filter by Group", "Homeroom- Oneschool", "Homeroom where oneschool is not a member"]
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
    And I should see select box with id of "search_criteria_grade" and contains ["3"]
    Then I press "Search for Students"
    And I should not see "Grader, Alpha_First"
    And I should see "Grader, Alpha_Third"

  Scenario twoschools
    Given load demo data 
    And I go to the home page
    And I fill in "Login" with "twoschools"
    And I fill in "Password" with "twoschools"
    Then I press "Login"
    Then I follow "School Selection"
    And I should see select box with id of "school_id" and contains ["Alpha Elementary", "Bravo Elementary"]
    And I should see "Alpha Elementary"
    And I should see "Bravo Elementary"
    Then I press "Choose School"
    And I should see select box with id of "search_criteria_grade" and contains ["3"]
    And I should see select box with id of "search_criteria_user_id" and contains ["2Second. twoschools"]
    And I should see select box with id of "search_criteria_group_id" and contains ["Homeroom where oneschool is not a member"]
    Then I follow "School Selection"
    And I select "Bravo Elementary" from "school_id"
    Then I press "Choose School"
    Then I should see "Bravo"
    Then I press "Search for Students"
    And I should see "Jones, Bravo_First"
    And I should see "Smith, Bravo_First"

  Scenario nouser
    When I go to the home page
    And I fill in "Login" with "invalid_user"
    And I press "Login"
    Then I should see "Authentication Failure"
    And I fill in "Login" with "oneschool"
    And I fill in "Password" with "wrong"
    And I press "Login"
    Then I should see "Authentication Failure"
     
    
  Scenario noschools
    Given load demo data 
    And I go to the home page
    And I fill in "Login" with "noschools"
    And I fill in "Password" with "noschools"
    Then I press "Login"
    Then I follow "School Selection"
    Then I should see "No schools available"
    And I should see "Splash Page"
    And I follow "Logout"
    And I should see "Logged Out"
    And I should see "Splash Page"
    

 

  Scenario nogroups
    Given load demo data 
    And I go to the home page
    And I fill in "Login" with "nogroups"
    And I fill in "Password" with "nogroups"
    Then I press "Login"
    Then I follow "School Selection"
    And I should see "Alpha Elementary"
    Then I press "Choose School"
    And I should see "User doesn't have access to any students at Alpha Elementary"
    And I should see "Choose School"
    


  Scenario allstudents
    Given load demo data 
    And I go to the home page
    And I fill in "Login" with "allstudents"
    And I fill in "Password" with "allstudents"
    Then I press "Login"
    Then I follow "School Selection"
    And I should see "Alpha Elementary"
    And I should see "Bravo Elementary"
    Then I press "Choose School"
    And I should see select box with id of "search_criteria_grade" and contains ["*", "1", "3","6"]
    And I should see select box with id of "search_criteria_user_id" and contains ["Filter by Group Member","1First. oneschool", "2Second. twoschools"]
    And I should see select box with id of "search_criteria_group_id" and contains ["Filter by Group", "Homeroom- Oneschool", "Homeroom where oneschool is not a member"]
    Then I press "Search for Students"
    And I should see "Grader, Alpha_First"
    And I should see "Grader, Alpha_Third"
