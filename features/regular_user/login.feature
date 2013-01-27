Feature: Login
  In order to maintain security of protected data
  A SIMS user
  Should have to log in before seeing secure pages

  Scenario: Log in on the splash page
    Given user "cuke_oneschool" with password "fr0d0L1v3s" exists
    And I go to the home page

    When I fill in "Login" with "cuke_oneschool"
		And I fill in "Password" with "fr0d0L1v3s"
		And I press "Login"

		Then I should not see "Please Login:"
		Then I should see "Logout"

  Scenario: Failed Login
    Given user "cuke_oneschool" with password "fr0d0L1v3s" exists
    And I go to the home page

    When I fill in "Login" with "cuke_oneschool"
		And I fill in "Password" with "fr0d0L1v3s2"
		And I press "Login"
    Then I should see "Authentication Failure"

    When I fill in "Login" with "cuke_oneschool"
		And I fill in "Password" with "fr0d0L1v3s"
		And I press "Login"

		Then I should not see "Please Login:"
    And I should not see "Authentication Failure"
		Then I should see "Logout"

  Scenario: Failed Login multiple districts persist district
    Given district "A"
    Given district "B"
    Given district "C"
    And I go to the home page
    Then "District" should have "A" district selected

    When I fill in "Login" with "cuke_oneschool"
		And I fill in "Password" with "fr0d0L1v3s2"
    And I select "B" from "District"
		And I press "Login"
    Then I should see "Authentication Failure"
    And "District" should have "B" district selected



  Scenario: Change password
    Given user "cuke_oneschool" with password "fr0d0L1v3s" exists
    And I go to the home page
    Then I should not see "Change Password"

    When I fill in "Login" with "cuke_oneschool"
		And I fill in "Password" with "fr0d0L1v3s"
		And I press "Login"
    And I follow "Change Password"


    When I fill in "Current password" with "wrong"
    And I fill in "Password" with "New"
    And I press "Change password"
    Then I should see "Current password is invalid"

    When I fill in "Current password" with "fr0d0L1v3s"
    And I press "Change password"
    Then I should see "Password cannot be blank"

    When I fill in "Current password" with "fr0d0L1v3s"
    And I fill in "Password" with "New"
    And I fill in "Password confirmation" with "Something else"
    And I press "Change password"
    Then I should see "Password doesn't match confirmation"


    When I fill in "Current password" with "fr0d0L1v3s"
    And I fill in "Password" with "New"
    And I fill in "Password confirmation" with "New"
    And I press "Change password"
    Then I should see "Your password has been changed"

    When I follow "Logout"
    And I fill in "Login" with "cuke_oneschool"
		And I fill in "Password" with "fr0d0L1v3s"
		And I press "Login"
    Then I should see "Please Login:"

    When I fill in "Password" with "New"
    And I press "Login"
    Then I should see "Logout"

  Scenario: Email confirmation of user with blank password and district key
    Given user "no_password" with no password in district with key "bnford"
    And I go to the home page

    When I fill in "Login" with "no_password"
    And I fill in "Password" with "cucumber"
    And I press "Login"
    Then I should see "Authentication Failure"

    When I fill in "Login" with "no_password"
    And I fill in "Password" with "bnford"
    And I press "Login"

    Then I should see "An email has been sent, follow the link to change your password."
    Then I should receive an email

    When I open the email

    Then I should see "change your password" in the email



    When I click the change_password link in the email
    Then I should see "Change your password"

    And I fill in "New password" with "cucumber"
    And I fill in "Confirm new password" with "cucumber"
    And I press "Change my password"

    Then I should see "Your password was changed successfully. You are now signed in."
