Feature: Principal Override Accept and Reject
  In order to facilitate team discussion and gather information
  A SIMS principal
  Should be able to accept or reject a principal override

  Background:
    Given common data
    And I am the principal
    And there is a principal override request
    And I start at the the search page
    And show me the page
    And I follow "1 Pending Request"

  Scenario: Reject without reason
    And I follow "Reject"
    And I press "Reject"
    Then I should see "Reason must be provided"

  Scenario: Reject with reason
    When I follow "Reject"
    And I press "Reject"
    And I fill in "principal_override_principal_response" with "Now you are a pickle, rejected by cucumber"
    And I press "Reject"
    Then I should see "Rejected"
    And "sims_cucumber_principal@example.com" should receive an email
    When "sims_cucumber_principal@example.com" open the email
    Then they should see "Now you are a pickle, rejected by cucumber" in the email body
    And they should see "[SIMS] Principal Override Rejected" in the email subject

  Scenario: Accept without prepared reasons
    And I follow "Accept"
    And I press "Accept"
    Then I should see "Reason must be provided"

  Scenario: Accept with reason
    And I follow "Accept"
    And I press "Accept"
    When I fill in "principal_override_principal_response" with "Approved in Brine"
    And I press "Accept"
    Then I should see "Approved"
    And "sims_cucumber_principal@example.com" should receive an email
    When "sims_cucumber_principal@example.com" open the email
    Then they should see "Approved in Brine" in the email body
    And they should see "[SIMS] Principal Override Accepted" in the email subject

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

