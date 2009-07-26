Feature: Principal Override Accept and Reject
  In order to facilitate team discussion and gather information
  A SIMS principal
  Should be able to accept or reject a principal override

  Background:
    Given common data
    And I am the principal
    And there is a principal override request
    And I am on the search page
    And I follow "1 pending request"

  Scenario: Reject
    And I follow "Reject"
    And I press "Reject"
    Then I should see "Reason must be provided"
    When I fill in "Reason for Rejecting this Request" with "Now you are a pickle, rejected by cucumber"
    And I press "Reject"
    Then I should see "Rejected"
    And I should receive an email
    When I open the email
    Then I should see "Now you are a pickle, rejected by cucumber" in the email
    And I should see "Principal Override Rejected" in the subject

  Scenario: Accept without prepared reasons
    And I follow "Accept"
    And I press "Accept"
    Then I should see "Reason must be provided"
    When I fill in "Reason for Accepting this Request" with "Approved in Brine"
    And I press "Accept"
    Then I should see "Approved"
    And I should receive an email
    When I open the email
    Then I should see "Approved in Brine" in the email
    And I should see "Principal Override Accepted" in the subject

  Scenario: Accept via radio button without autopromote
    Given Principal Override Reason "predefined reason 1" ""
    And Principal Override Reason "predefined reason 2" ""
    When I follow "Accept"
    Then I should see "predefined reason 1"
    Then I should see "predefined reason 2"
    And I press "Accept"
    Then I should not see "3- tier3"
    

  Scenario: Accept via radio button with autopromote
    Given Principal Override Reason "predefined reason 1" ""
    And Principal Override Reason "predefined reason 2" "autopromote"
    And tiers ["tier1", "tier2", "tier3"]
    And I follow "Accept"
    And I choose "predefined reason 2"
    And I press "Accept"
    Then I should see "3 - tier3"
    And I show page

