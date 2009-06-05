Feature: Checklist Builder
  In order to create a checklist for the district
  A SIMS content builder
  Should be able to create checklists

  Background:
    Given I log in as content_builder
    And I follow "Checklist Builder"


  Scenario: Create Checklist
    When I follow "Add New Checklist Definition"
    And I fill in "Text" with "This is the text"
    And I press "Create"
    Then I should see "Directions can't be blank"
    When I fill in "Directions" with "These are the directions"
    And I press "Create"	
    Then I follow "Edit"
    And I check "Check to make this the active checklist"
    Then I press "Update"
    Then I follow "Preview"
    Then I should see "Preview of Checklist Definition"

