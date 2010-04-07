Feature: Create Intervention
  In order to use interventions
  A SIMS USER
  Should be able to create and select an interventon
  
  Background:
    Given common data

  Scenario: Create
    Given I start at the student profile page
    And I follow "Select New Intervention and Progress Monitor from Menu"

    # same as intervention
    And I select "Some Goal" from "goal_definition_id"
    And I press "Choose Goal"

    And I select "Some Objective" from "objective_definition_id"
    And I press "Choose Objective"

    And I select "Some Category" from "intervention_cluster_id"
    And I press "Choose Category"

    And I fill in "Add new comment about the intervention plan and progress" with "test cucumber comment"
    And I should not see "Edit/view scores"
    And I press "Save"
    When I follow "Edit/Add Comment"
    Then I should see "test cucumber comment"

  Scenario: Edit an existing intervention with no progress monitors available
    Given an intervention with no progress monitors
    Given I start at the student profile page
    When I follow "Edit/Add Comment"
    Then I should not see "Enter/view scores"

  Scenario: Edit an existing intervention with a progress monitor selected
    And I need to figure out why this isn't working it is more of a testing issue
    Given an intervention with one progress monitor chosen but no recommended monitors
    Given I start at the student profile page
    When I follow "Edit/Add Comment"
    Then I should see "Enter/view scores"
    When I follow "Enter/view scores"
    Then I should see "preview bar graph"

  Scenario: Edit an existing intervention with a progress monitor selected, but no recommended monitors
    And I need to figure out why this isn't working it's ticket 283
    Given an intervention with one progress monitor chosen and one recommended monitor
    Given I start at the student profile page
    When I follow "Edit/Add Comment"
    Then I should see "Assign Progress Monitor"
    Then I should see "Enter/view scores"
    
    When I follow "Enter/view scores"
    Then I should see "preview bar graph"

  Scenario: Edit an existing intervention with progress monitors available but none selected
    Given an intervention with two progress monitors but none selected
    Given I start at the student profile page

    When I follow "Edit/Add Comment"
    And I should see onchange for "Assign Progress Monitor" that calls "ajax_probe_assignment"

    And I select "First Progress Monitor" from "Assign Progress Monitor"
    And xhr "onchange" "Assign Progress Monitor"

    Then I should see "Enter/view scores"
    And xhr "onclick" "enter_view_score_link"
    Then I should see "Preview Bar Graph"

  Scenario: Add a comment to an existing intervention with a different creator
    #312, intervention comments can have different authors than intervention creator
    Given an intervention with no progress monitors
    Given I start at the student profile page
    When I follow "Edit/Add Comment"
    And I fill in "Add new comment about the intervention plan and progress" with "test cucumber comment"
    And I press "Save"
    When I follow "Edit/Add Comment"
    Then I should see "test cucumber comment by default user"
