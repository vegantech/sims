Feature: Intervention Quicklist
  In order to save time, and be more consisten
  A SIMS USER
  Should be able to use a quicklist

  Scenario: Select From Quicklist without javascript
    Given common data
    And quicklist choices ["Most Used Intervention"]
    And I am on student profile page
    And I follow "Assign New Intervention"
    And I should see "Intervention Quicklist"
    And I select "Most Used Intervention" from "Intervention Quicklist"
    And I press "Pick from Quicklist"
    
    #And I complete "Assign New Intervention"

  Scenario: Not in custom
    Given common data
    And I am on student profile page
    And I follow "New Custom Intervention"
    And I should not see "Intervention Quicklist"

