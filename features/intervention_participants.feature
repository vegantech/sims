Feature: Assign Participants to Intervention
  In order to use assign participants to an intervention
  A SIMS USER
  Should be able to create an intervention and then assign participants

  Scenario: Create Custom
    #Assuming itnerventions currently work correctly and we're going to piggyback on that
    Given common data
    And there are "0" emails
    And I am on student profile page
    And I complete "Assign New Intervention"
    And I follow "Edit"
    And I am now pending
    When I follow "Add Participant"
    And I select "Firstcucumber_another Last_Name" from "intervention_participant_user_id"
    And I select "Participant" from "intervention_participant_role"
    And I press "Add Participant"
    Then I should see "Participant added"
    And there are "2" emails
    And there is an email containing "Firstcucumber_another Last_Name"
    
    # check that the email was sent
