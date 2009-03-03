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
