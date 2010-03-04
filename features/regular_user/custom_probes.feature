Feature: Create Custom Probes
  In order to use custom probes
  A SIMS USER
  Should be able to create and select a custom probe

  Scenario: Create Custom
    #Assuming itnerventions currently work correctly and we're going to piggyback on that
    Given common data

    And I start at the student profile page
    Then I follow "Create New Custom Intervention and Progress Monitor"
    And I select "Some Goal" from "goal_definition_id"
    And I press "Choose Goal"

    And I select "Some Objective" from "objective_definition_id"
    And I press "Choose Objective"

    And I select "Some Category" from "intervention_cluster_id"
    And I press "Choose Category"

    And I fill in "Title" with "Custom Intervention Name"
    And I fill in "Description" with "Custom Description"
    And I select "2" from "Frequency"
    And I select "2" from "Duration"
    And I select "Some Tier" from "Tier"

    # and anything else that isn't already there or derivable Intervention definition gets created
    # along with intervention using data from intervention and custom flag (intervention, description, title, tier) [user,school, disabled=false]
    And I select "Create Custom" from "Assign Progress Monitor"
    When I press "Save"
    #It should be invalid, but allow me to enter scores now
    Then I should see "Min score"
    When I fill in "intervention_intervention_probe_assignment_probe_definition_attributes_title" with "PTitle1"
    And I fill in "intervention_intervention_probe_assignment_probe_definition_attributes_description" with "PDesc1"
    And I fill in "Min score" with "100"
    And I fill in "Max score" with "0"
    And I press "Save"
    #scores are invalid
    Then I should see "Min score"
    And I fill in "Max score" with "100"
    And I fill in "Min score" with "0"
    And I press "Save"
    Then I should not see "Min score"
  
    
    # And I go Back to student profile screen
    And I follow "Select New Intervention and Progress Monitor from Menu"

    And I select "Some Goal" from "goal_definition_id"
    And I press "Choose Goal"

    And I select "Some Objective" from "objective_definition_id"
    And I press "Choose Objective"

    And I select "Some Category" from "intervention_cluster_id"
    And I press "Choose Category"
    
    And I select "(c) Custom Intervention Name" from "intervention_definition_id"
    And I press "Choose Intervention"

    Then page should contain "PTitle1"


