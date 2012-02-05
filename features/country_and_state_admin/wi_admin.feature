Feature: Sims Demo Walkthrough
  In order to manage wisconsin districts
  The state admin must be able to do so
 
 Scenario: test wi_admin
    Given load demo data
    When I enter url "http://www.example.com/?district_abbrev=admin"
    When I fill in "Login" with "district_admin"
    And I fill in "Password" with "district_admin"
    And I press "Login"
    Then I should see "Wisconsin Administration"
    When I follow "Manage Districts"
    Then I should see "Listing districts in"
    And I follow Delete within "tbody"
    Then I should see "Have the district admin remove the schools first."
    When I follow "New District"
    And I fill in "Name" with "Cucumber"
    And I fill in "Abbrev" with "cuke"
    And I press "Create"
    Then I should see "District was successfully created"
    When I follow Delete within "#cuke_tr"
    Then I should not see "Have the district admin remove the schools first."
    And I should not see "cuke"
