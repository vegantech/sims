Feature: Intervention Builder
  In order to create a new intervention definition
  A content builder user
  Should be able to create a hierarchy for the intervention definition

  Scenario: Build New Everything
    Given I log in as content_builder
    And I follow "Intervention Builder"

    When I follow "New Goal"
    And I fill in "Title" with "Goal Title"
    And I fill in "Description" with "Goal Description"
    And I press "Create"
    Then I should see "Goal was successfully created."
    And I should see "Listing Goals"

    When I follow "See Objectives"
    Then I should see "Listing Objectives"

    When I follow "New Objective"
    And I fill in "Title" with "Objective Title"
    And I fill in "Description" with "Objective Description"
    And I press "Create"
    Then I should see "Objective was successfully created."
    Then I should see "Listing Objectives"

    When I follow "See Categories"
    Then I should see "Listing Categories"

    When I follow "New Category"
    And I fill in "Title" with "Category Title"
    And I fill in "Description" with "Category Description"
    And I press "Create"
    Then I should see "Category was successfully created."
    Then I should see "Listing Categories"

    When I follow "See Interventions"
    Then I should see "Listing Interventions"

    When I follow "New Intervention"
    And I fill in "Title" with "Intervention Title"
    And I fill in "Description" with "Intervention Description"
    And I press "Create"
    Then I should see "Intervention was successfully created."
    Then I should see "Listing Interventions"

  Scenario: Intervention Filter
    Given I log in as content_builder
    And there is an intervention_definition that is "enabled" and "system"
    And there is an intervention_definition that is "enabled" and "custom"
    And there is an intervention_definition that is "disabled" and "system"
    And there is an intervention_definition that is "disabled" and "custom"

    And I follow "Intervention Builder"
    And I follow "See Objectives"
    And I follow "See Categories"
    And I follow "See Interventions"

    Then I should see "Enabled System"
    Then I should see "Enabled Custom"
    Then I should not see "Disabled System"
    Then I should not see "Disabled Custom"

    Then the "Enabled" checkbox should be checked
    When I check "Disabled"
    And I press "Filter"


    Then I should see "Enabled System"
    Then I should see "Enabled Custom"
    Then I should see "Disabled System"
    Then I should see "Disabled Custom"

    When I uncheck "Custom"
    When I check "System"
    And I press "Filter"

    Then the "Custom" checkbox should not be checked
    Then I should see "Enabled System"
    Then I should not see "Enabled Custom"
    Then I should see "Disabled System"
    Then I should not see "Disabled Custom"

    When I uncheck "Disabled"
    And I press "Filter"
    Then I should see "Enabled System"
    Then I should not see "Enabled Custom"
    Then I should not see "Disabled System"
    Then I should not see "Disabled Custom"

    When I uncheck "System"
    And I check "Custom"
    And I press "Filter"
    Then I should not see "Enabled System"
    Then I should see "Enabled Custom"
    Then I should not see "Disabled System"
    Then I should not see "Disabled Custom"

    When I check "Disabled"
    And I check "Custom"
    And I press "Filter"
    Then I should not see "Enabled System"
    Then I should see "Enabled Custom"
    Then I should not see "Disabled System"
    Then I should see "Disabled Custom"

  Scenario: Disable Selected Interventions
    Given I log in as content_builder
    And there is an intervention_definition that is "enabled" and "system"
    And there is an intervention_definition that is "enabled" and "custom"
    And there is an intervention_definition that is "disabled" and "system"
    And there is an intervention_definition that is "disabled" and "custom"

    And I follow "Intervention Builder"
    And I follow "See Objectives"
    And I follow "See Categories"
    And I follow "See Interventions"
    And I press "Disable Selected Interventions"
    Then I should see "0 Intervention Definitions disabled"

    And I check "ck_1"
    And I check "ck_2"
    And I press "Disable Selected Interventions"
    Then I should see "2 Intervention Definitions disabled"

    When I uncheck "Disabled"
    And I press "Filter"
    Then I should not see "Recommend Progress Monitors"



   







