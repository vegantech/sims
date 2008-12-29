Feature: From Scratch
  In order to setup a new system
  A System Admin
  Should be able to bootstrap a system from nothing.

  Scenario: System Admin
    Given System Bootstrap
    When I go to the home page
    Then I should see "Login"
    When I fill in "Login" with "district_admin"
    And I fill in "Password" with "district_admin"
    Then I press "Login"
    Then I follow "Manage Countries"
    Then I follow "New country"
    And I fill in "Name" with "United States"
    And I fill in "abbrev" with "us"
    And I press "Create"

    Then I follow "Logout"
    When I go to the home page
    When I fill in "Login" with "district_admin"
    And I fill in "Password" with "district_admin"
    Then I press "Login"
    Then I should not see "Manage Countries"

