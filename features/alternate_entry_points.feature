Feature: Alternate Entry Points
  In order to use links from external applications to SIMS
  A SIMS user
  Should be able to visit that url after login and not have errors generated in subsequent page visits
  
  Scenario: External Link to student profile Without Prior Login
    Given common data
    # And I enter url "/students/996332878"
    And I enter default student url
    And I should see "You must be logged in to reach that page"
    And I fill in "Login" with "default_user"
    And I fill in "Password" with "default_user"
    And I press "Login"
    And I should not see "Authentication Failure"
    Then I should see "Intervention and Progress Monitoring"
    And I should see "Last, Common"


  Scenario oneschool intervention email
    Given load demo data
    When I enter url "/interventions/184330814/edit"
    Then I should see "Login"
    And I select "WI Test District" from "District"
    And I fill in "Login" with "oneschool"
    And I fill in "Password" with "oneschool"
    Then I press "Login"
    Then I should see "Add new comment about the intervention plan"
