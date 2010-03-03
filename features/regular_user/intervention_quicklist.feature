Feature: Intervention Quicklist
  In order to save time, and be more consisten
  A SIMS USER
  Should be able to use a quicklist

  Scenario: Select From Quicklist without javascript
    Given common data
    And quicklist choices ["Quicklist Item 1", "Quicklist Item 2"]
    And I start at the student profile page
    And I follow "Select from Intervention Quicklist"
    And I should see "Intervention Quicklist"
    And I select "Quicklist Item 1" from "Intervention Quicklist"
    When I press "Pick from Quicklist"
    #Then I should see "Quicklist Item 1"
    And page should contain "Save"
    #When I select "Some Goal" from "goal_definition_id"
    #And I press "Choose Objective"
    #Then I should see "Quicklist Item 1"
    #Then I should see "Quicklist Item 2"

    
    #And I complete "Assign New Intervention"

  Scenario: Not in custom
    Given common data
    And quicklist choices ["Quicklist Item 1", "Quicklist Item 2"]
    And I start at the student profile page
    And I follow "New Custom Intervention"
    And I should not see "Intervention Quicklist"

  Scenario: No Quicklist items
    Given common data
    And I start at the student profile page
    And I follow "New Custom Intervention"
    And I should not see "Intervention Quicklist"


