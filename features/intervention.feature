Feature: Create Intervention
  In order to use custom interventions
  A SIMS USER
  Should be able to create and select an interventon

  Scenario: Create

    Given common data
    And I am on student profile page
    And I follow "Select New Intervention and Progress Monitor from Menu"

    # same as intervention
    And I select "Some Goal" from "goal_definition_id"
    And I press "Choose Goal"

    And I select "Some Objective" from "objective_definition_id"
    And I press "Choose Objective"

    And I select "Some Category" from "intervention_cluster_id"
    And I press "Choose Category"

    And I fill in "Add new comment about the intervention plan and progress" with "test cucumber comment"
    And I press "Save"
    When I follow "Edit/Add Comment"
    Then I should see "test cucumber comment"

