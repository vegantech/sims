Feature: District Logs
  In order to troubleshoot login failures and see logins
  A SIMS district admin
  Should be able to see a log of successful and unsuccessful authentication attempts

  Scenario: Log
    Given I am a district admin
    And I go to the home page
    And I follow "Logout"
    And I fill in "Login" with "cuke_oneschool"
    And I fill in "Password" with "something wrong"
    And I press "Login"
    And I fill in "Login" with "default_user"
    And I fill in "Password" with "default_user"
    And I press "Login"
    When I follow "District Log"
    Then I should see "Successful login of default user"
    And I should see "Failed login of cuke_oneschool"


  Scenario: LogFilter
    Given I am a district admin
    And I go to the home page
    And I follow "Logout"
    And I fill in "Login" with "cuke_oneschool"
    And I fill in "Password" with "something wrong"
    And I press "Login"
    And I fill in "Login" with "cuke_invalid"
    And I fill in "Password" with "something wrong"
    And I press "Login"
    And I fill in "Login" with "default_user"
    And I fill in "Password" with "default_user"
    And I press "Login"
    When I follow "District Log"
    Then I should see "Successful login of default user"
    And I should see "Failed login of cuke_oneschool"
    When I fill in "filter" with "cuke"
    And I press "Filter Results"
    Then I should see "Failed login of cuke_oneschool"
    And I should not see "Successful login of default user"
