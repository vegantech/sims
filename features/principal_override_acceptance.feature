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

  Scenario: Accept via radio button without autopromote

  Scenario: Accept via radio button with autopromote

