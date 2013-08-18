Feature: Sims Demo Walkthrough
  In order to show a demo works

  Scenario: Run Demo with oneschool
    Given load demo data
    And I go to the home page
    And I select "WI Test District" from "District"
    And I fill in "Login" with "oneschool"
    And I fill in "Password" with "oneschool"
    Then I press "Login"
    And I should see "Logout"
    And I should not see "news_item"
    And I should not see "WI Test District Administration"
    Then I follow "School Selection"
#    And I should see "Alpha Elementary"
#    Then I press "Choose School"
    And I choose "List only students in an active intervention"

    #lighthouse #162
    And I check "Math"
    Then I press "Search for Students"

    Then I follow "Student Search"
    Then I press "Search for Students"
    And I should see "Grader, Alpha_First"
    And I should see "Grader, Alpha_Third"
    When I press "select for problem solving"
    Then I should see "No students selected"
    When I should click js "all"
    Then I press "select for problem solving"
    And I should see "Student 1 of 2"
    Then I follow "Next"
    And I should see "Student 2 of 2"

    #custom flag
    Then I follow "Create Custom Flag"
    And I fill in "custom_flag_reason" with "test reason from cucumber"
    And I select "Math" from "Category"
    Then I press "Save Custom Flag"
    Then I should see "Math" within "#customflag li"
    And I should see "test reason from cucumber" within "#customflag li"
    Then I follow "Remove"
    Then I should not see "test reason from cucumber"


    #creating and editing score #195
    #also 211 for verifying score date.

    Then I follow "Select New Intervention and Progress Monitor from Menu"
    Then I select "Learning" from "goal_id"
    Then I press "Choose Goal"
    Then I select "Language Arts" from "objective_id"
    Then I press "Choose Objective"
    Then I select "Reading problems" from "category_id"
    Then I press "Choose Category"
    Given PENDING intervention definitions is empty
    Then I select "Reading one" from "intervention_definition_id"
    Then I press "Choose Intervention"

    Then I should see select box with id of "Assign Intervention" and contains "Reading one"
    Then I press "Save"

    Then I follow "Edit/Add Comment"
    Given PENDING as enter/view scores link does not degrade?
    Then I follow "Enter/view scores"
    Then I select "2007" from "intervention[intervention_probe_assignment][new_probes]_0_administered_at"
    Then I fill in "Score" with "15"
    Then I press "Save"


    Then I follow "Edit/Add Comment"
    Then I follow "Enter/View scores"
    Then I should see ", 2007"
    Then I follow "Edit Score"
    Then I fill in "Score" with "25"
    Then I press "Save"

    # lighthouse ticket #272 begin
    Then I follow "Alpha_Third Grader"
    When I follow "Edit/Add Comment"
    And I follow "Enter/view scores"
    And I fill in "Score" with "fifteen"
    And I fill in "Add new comment about the intervention plan and progress" with "A comment with a text score triggers bug 272."
    And I press "Save"
    Then I should not see "NoMethodError"
    And the "Add new comment about the intervention plan and progress" field should contain "A comment with a text score triggers bug 272."
    #Fix redisplay of score

    # Then I follow "Enter/view scores"
    # And the "Score" field should contain "fifteen"

    # lighthouse ticket #272 end




    Then I follow "Alpha_Third Grader"
    Then I follow "Edit/Add Comment"
    Then I follow "Delete"


    # intervention ticket #185
    Then I follow "Select New Intervention and Progress Monitor from Menu"
    Then I select "Learning" from "goal_id"
    Then I press "Choose Goal"
    Then I select "Math" from "objective_id"
    Then I press "Choose Objective"
    Then I select "Arithmetic problems" from "category_id"
    Then I press "Choose Category"
    Then I select "Arithmetic one" from "intervention_definition_id"
    Then I press "Choose Intervention"
    # And I should see "value=\"777239083\" selected=\"selected\""
    # Fact interview A
    # And I select "" from "Assign Progress Monitor"
    # change some options here?
    Then I press "Save"
    Then I should see "Please assign a progress monitor"
    Then I follow "Edit/Add Comment"
    And page source should contain /<option value=\"\"></option>/
    And page source should contain "Fact Interview A</option>\n"
    And page source should contain "Fact Interview B</option></select>"
    And I follow "Delete"


    Then I follow "Select New Intervention and Progress Monitor from Menu"
    Then I select "Learning" from "goal_id"
    Then I press "Choose Goal"
    Then I select "Math" from "objective_id"
    Then I press "Choose Objective"
    Then I select "Arithmetic problems" from "category_id"
    Then I press "Choose Category"
    Then I select "Arithmetic one" from "intervention_definition_id"
    Then I press "Choose Intervention"

    #And I should see "value=\"777239083\" selected=\"selected\""
    #Fact interview A

    #change some options here?
    Then I press "Save"
    Then I follow "Edit/Add Comment"
    #And I should see "value=\"777239083\" selected=\"selected\""
    And I press "Save"


    #They choose them now ^^^

    #principal overrides
    Then I follow "Request Principal Override to unlock next tier"
    And I fill in "Reason for Request" with "My Demo Test Reason"
    And I press "Submit"
    Then I should see "PrincipalOverride was successfully created and sent"
    And I should see "1 Override Request"

    #empty checklist
    Then I follow "Complete a Checklist for this Student"
    Then I press "Submit and Make Recommendation"

    #draft recommendation
    Then I press "Save Draft"
    And I follow "view"
    And I follow "Student Report"
    And I press "Generate Report"

    And I follow "Student Interventions"
    And I press "Generate Report"


    And PENDING I am now pending
    When I follow "Assign Monitors"
    And I check "Fact Interview A"
    And I select "2014" from "First Date"
    And I select "2013" from "End Date"
    Then I press "Create"

    Then I follow "Assign Monitors"
    And page should contain "\"selected\" value=\"2014\""
    And page should contain "\"selected\" value=\"2013\""
    Then I follow "back"

    Then I follow "Enter scores for previously administered assessment"
    Then I fill in "score" with "2"
    Then I press "Enter Score"
    Then I should see "Hide Graph"
    And I should see "Score: 2"

    Then I follow "Add Participant"
    Then I select "2Second. twoschools" from "intervention_participant_user_id"
    Then I press "Add Participant"
    Then I follow "Administer Assessment"

    And I fill in "answer_1" with "2"
    And I press "Submit Without Printing"
    And I should see "Score: 1"
    Then I follow "Back"


  Scenario: Alphaprin
    Given load demo data
    And I go to the home page
    And I select "WI Test District" from "District"
    And I fill in "Login" with "alphaprin"
    And I fill in "Password" with "alphaprin"
    Then I press "Login"
    And I should see "Logout"
    Then I follow "School Selection"
#    And I should see "Alpha Elementary"
#    Then I press "Choose School"
    And I should see select box with id of "search_criteria_grade" and contains ["*", "1", "3","6"]
    And I should see select box with id of "search_criteria_user_id" and contains ["All Staff","1First. oneschool","2Second. twoschools"]
    And I should see select box with id of "search_criteria_group_id" and contains ["Filter by Group","Class where oneschool and twoschools have students" , "Homeroom where oneschool is not a member","Homeroom- Oneschool"]
    Then I press "Search for Students"
    And I should see "Grader, Alpha_First"
    And I should see "Grader, Alpha_Third"


  Scenario: alphagradethree
    Given load demo data
    And I go to the home page
    And I select "WI Test District" from "District"
    And I fill in "Login" with "alphagradethree"
    And I fill in "Password" with "alphagradethree"
    Then I press "Login"
    Then I follow "School Selection"
#    And I should see "Alpha Elementary"
#    Then I press "Choose School"
    And I should see select box with id of "search_criteria_grade" and contains ["3"]
    Then I press "Search for Students"
    And I should not see "Grader, Alpha_First"
    And I should see "Grader, Alpha_Third"

  Scenario: twoschools
    Given load demo data 
    And I go to the home page
    And I select "WI Test District" from "District"
    And I fill in "Login" with "twoschools"
    And I fill in "Password" with "twoschools"
    Then I press "Login"
    Then I follow "School Selection"
    And I should see select box with id of "school_id" and contains ["Alpha Elementary", "Bravo Elementary"]
    And I should see "Alpha Elementary"
    And I should see "Bravo Elementary"
    Then I press "Choose School"
    And I should see select box with id of "search_criteria_grade" and contains ["*","1","3"]
    And I should see select box with id of "search_criteria_user_id" and contains ["All Staff", "1First. oneschool", "2Second. twoschools"]
    And I should see select box with id of "search_criteria_group_id" and contains ["Filter by Group", "Class where oneschool and twoschools have students", "Homeroom where oneschool is not a member"]
    Then I follow "School Selection"
    And I select "Bravo Elementary" from "school_id"
    Then I press "Choose School"
    Then I should see "Bravo"
    Then I press "Search for Students"
    And I should see "Jones, Bravo_First"
    And I should see "Smith, Bravo_First"

  Scenario: nouser
    Given load demo data
    When I go to the home page
    And I fill in "Login" with "invalid_user"
    And I press "Login"
    Then I should see "Authentication Failure"
    And I fill in "Login" with "oneschool"
    And I fill in "Password" with "wrong"
    And I press "Login"
    Then I should see "Authentication Failure"


  Scenario: noschools
    Given load demo data
    And I go to the home page
    And I select "WI Test District" from "District"
    And I fill in "Login" with "noschools"
    And I fill in "Password" with "noschools"
    Then I press "Login"
    Then I follow "School Selection"
    Then I should see "No schools available"
    And I should not see "Please Login"
    And I follow "Logout"
    And I should see "Please Login"


  Scenario: nogroups
    Given load demo data
    And I go to the home page
    And I select "WI Test District" from "District"
    And I fill in "Login" with "nogroups"
    And I fill in "Password" with "nogroups"
    Then I press "Login"
    Then I follow "School Selection"
    And I should see "User doesn't have access to any students at Alpha Elementary"



  Scenario: allstudents
    Given load demo data
    And I go to the home page
    And I select "WI Test District" from "District"
    And I fill in "Login" with "allstudents"
    And I fill in "Password" with "allstudents"
    Then I press "Login"
    Then I follow "School Selection"
    And I should see "Alpha Elementary"
    And I should see "Bravo Elementary"
    Then I press "Choose School"
    And I should see select box with id of "search_criteria_grade" and contains ["*", "1", "3","6"]
    And I should see select box with id of "search_criteria_user_id" and contains ["All Staff","1First. oneschool", "2Second. twoschools"]
    And I should see select box with id of "search_criteria_group_id" and contains ["Filter by Group", "Class where oneschool and twoschools have students", "Homeroom where oneschool is not a member", "Homeroom- Oneschool"]
    Then I press "Search for Students"
    And I should see "Grader, Alpha_First"
    And I should see "Grader, Alpha_Third"

