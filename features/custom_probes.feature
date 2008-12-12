Feature: Create Custom Probes
  In order to use custom probes
  A SIMS USER
  Should be able to create and select a custom probe

  Scenario: Create Custom
    #Assuming itnerventions currently work correctly and we're going to piggyback on that
    Given common data

    And I am on student profile page
#    And I "Assign New Intervention"

    And I follow "Assign New Intervention"

    And I select "Some Goal" from "goal_definition_id"
    And I press "Choose Goal"

    And I select "Some Objective" from "objective_definition_id"
    And I press "Choose Objective"

    And I select "Some Category" from "intervention_cluster_id"
    And I press "Choose Category"
    And I press "Create"


    And I follow "Assign Monitors"
    And I follow "Assign Custom Probe"
    And I press "Create"
    Then I should see "Title can't be blank"
    
    And I fill in "Title" with "Custom Probe Title1"
    And I fill in "Description" with "Custom Description"
    And I fill in "Min score" with "1"
    And I fill in "Max score" with "10"
    And I press "Create"
    
    Then I should see "Assign Custom Probe"
    And I Display Body
    And I am pending
    Then the "Custom Probe Title1" checkbox should be checked
    Then I complete "Assign New Intervention"
    #It's assigned
    Then I should see "Custom Probe Title1 has been automatically assigned"

    


