Feature: Assign Participants to Intervention
  In order to use assign participants to an intervention
  A SIMS USER
  Should be able to create an intervention and then assign participants

  Scenario: Create Custom
    #Assuming interventions currently work correctly and we're going to piggyback on that
    Given common data
    And there are "0" emails
    And I am on student profile page
    When I complete "Assign New Intervention"
    And I follow "Edit/Add Comment"

    # Yes.  The following line of code is lame.
    # Basically, I did not want to accept a false match on "default user" higher on the page.
    Then I should see "\ndefault user\n<input id="intervention_participant_user_ids_"

    # And I show page
    And I am now pending
    When I follow "Add Participant"
    And I select "Firstcucumber_another Last_Name" from "intervention_participant_user_id"
    And I select "Participant" from "intervention_participant_role"
    And I press "Add Participant"
    Then I should see "Participant added"
    And there are "2" emails
    And there is an email containing "Firstcucumber_another Last_Name"

    # check that the email was sent

  Scenario: Add Participant to new Intervention
    Given common data
    And there are "0" emails
    And I am on student profile page
    When I follow "Select New Intervention and Progress Monitor from Menu"
    And I select "Some Goal" from "goal_definition_id"
    And I press "Choose Goal"
    And I select "Some Objective" from "objective_definition_id"
    And I press "Choose Objective"
    And I select "Some Category" from "intervention_cluster_id"
    And I press "Choose Category"
    And I check "Assign yourself to this intervention"
    When I follow "Add Participant"
    # Then I show page
    And I select "Firstcucumber_another Last_Name" from "intervention_participant_user_ids_"
    And I press "Save"
    Then there are "1" emails
      #(One to both users)
    # verify user is a participant
    # verify other user is a participant

  
 Scenario: Add same Participant and select checkbox
    Given common data
    Given with additional student
    And there are "0" emails
    And I am on student profile page
    When I follow "Select New Intervention and Progress Monitor from Menu"
    And I select "Some Goal" from "goal_definition_id"
    And I press "Choose Goal"
    And I select "Some Objective" from "objective_definition_id"
    And I press "Choose Objective"
    And I select "Some Category" from "intervention_cluster_id"
    And I press "Choose Category"
    And I check "Assign yourself to this intervention"
    And I check "Apply to all selected students"
    When I follow "Add Participant"
    # Then I show page
    And I select "default user" from "intervention_participant_user_ids_"
    And I press "Save"
    # verify user is a participant
    # verify other user is a participant
    #...

    Then there are "1" emails
    # one to each user(1),  even though there are multiple students
    When I follow "Edit/add comment"
    And I press "Save"

    #It should not blow up
    

