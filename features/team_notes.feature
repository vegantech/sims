Feature: Team Notes
  In order view team notes in batches
  A SIMS user
  Should be able to view Team Notes report
  
  Scenario: Show Team Notes
    Given I go to the school selection page
    When I follow "Team Notes"
    Then I should see "For Date"