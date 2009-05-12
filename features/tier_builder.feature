Feature: Tier Builder
  In order to use the tier builder
  A content builder user
  Should be able to create, edit, reorder, and destroy the tier

  Scenario: Tier Builder
    Given I log in as content_builder
    And I follow "Tier Builder"

    When I follow "New Tier"
    And I fill in "Title" with "Spelled Inkorrect"
    And I press "Spellcheck"
    And I should see "1 Spelling error detected"
    And I press "Create"

    And I follow "Edit"
    And I fill in "Title" with "Incorrect"
    And I press "Update"

    Then I should see "Incorrect"
    
    Then I follow "Delete"
    Then I should not see "Incorrect"


    And I am pending until  I can test move

