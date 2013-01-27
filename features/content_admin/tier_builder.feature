Feature: Tier Builder
  In order to use the tier builder
  A content builder user
  Should be able to create, edit, reorder, and destroy the tier

  Scenario: Tier Builder
    Given I log in as content_builder
    And I follow "Tier Builder"

    When I follow "New tier"
    And I fill in "Title" with "Spelled Inkorrect"
    And PENDING I am now pending
    And I press "Check Spelling"
    And I should see "1 Spelling error detected"
    And I press "Create"

    And I follow "Edit"
    And I fill in "Title" with "Incorrect"
    And I press "Update"

    Then I should see "Incorrect"

    Then I follow "Delete"
    Then I should not see "Incorrect"

    When I follow "New Tier"
    And I fill in "Title" with "Spelled Inkorrect"
    And I press "Create"

    When I follow "New Tier"
    And I fill in "Title" with "Spelled Correctly"
    And I press "Create"
    And I should see "Spelled Inkorrect" within "tr.tier:first-of-type"

    And I press within tr.tier:last-of-type
    And I should see "Spelled Inkorrect" within "tr.tier:last-of-type"

  Scenario: Remove Tier in use
    Given load demo data
    And I go to the home page
    And I select "WI Test District" from "District"
    And I fill in "Login" with "content_builder"
    And I fill in "Password" with "content_builder"
    And I press "Login"

    And I follow "Tier Builder"

    Then I follow "Delete" within "tr.tier:first-of-type"
    And I should see "This tier is in use. Are you sure you want to move everything to 2 - Targeted?"
    And I follow "Cancel"
    And I should see "Broad"

    Then I follow "Delete" within "tr.tier:first-of-type"
    And I should see "This tier is in use. Are you sure you want to move everything to 2 - Targeted?"
    And I press "Delete"
    And I should not see "Broad"
    And I should see "Records have been moved to the 2 - Targeted tier"
    And PENDING maybe I should confirm this or just trust my unit tests

