Feature: Principal Override Request
  In order to facilitate team discussion and gather information
  A SIMS user
  Should be able to create principal override

  Background:
    Given common data
    And I start at the the student profile page

  Scenario: Request Principal Override when there are no tiers
    Given there are no tiers
    When I follow "Request Principal Override to unlock next tier"
    Then I should see "Overrides unavailable, no tiers defined."

  Scenario: Request Principal Override when there are no principals
    When I follow "Request Principal Override to unlock next tier"
    Then I should see "There are no principals assigned to this student"

  Scenario: Request Principal Override when there are principals
    When I follow "Request Principal Override to unlock next tier"
    And PENDING I fill it in with "something"
    And PENDING I press the button
    Then PENDING I should see 1 override requests
    When PENDING I follow 1 override requests
    Then PENDING I should see delete

