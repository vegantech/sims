Feature: Create Custom Intervention
  In order to use custom interventions
  A SIMS USER
  Should be able to create and select a custom interventon

  Scenario: Create Custom
    #Assuming itnerventions currently work correctly and we're going to piggyback on that

    Given common data
    And I am on student profile page
    And I follow "New Custom Intervention"

    # same as intervention
    And I select "Some Goal" from "goal_definition_id"
    And I press "Choose Goal"

    And I select "Some Objective" from "objective_definition_id"
    And I press "Choose Objective"

    And I select "Some Category" from "intervention_cluster_id"
    And I press "Choose Category"

    And I fill in "Title" with "Custom Intervention Name"
    And I fill in "Description" with "Custom Description"
    And I select "Some Tier" from "Tier"

    # and anything else that isn't already there or derivable Intervention definition gets created
    # along with intervention using data from intervention and custom flag (intervention, description, title, tier) [user,school, disabled=false]
    When I press "Create"
    # And I go Back to student profile screen
    And I follow "Assign New Intervention"

    And I select "Some Goal" from "goal_definition_id"
    And I press "Choose Goal"

    And I select "Some Objective" from "objective_definition_id"
    And I press "Choose Objective"

    And I select "Some Category" from "intervention_cluster_id"
    And I press "Choose Category"

    Then I should see "Custom Intervention Name"

