Feature: Forgot Password
    In order to recover a lost password
    A SIMS user
    Should be able to recover their password by email

    Scenario: District with forgot password disabled
        Given user "cuke_oneschool" with password "fr0d0L1v3s" exists
        When I go to the home page
        Then I should not see "Forgot Password"

    Scenario: Expired Token
        When I enter url "/change_password?token=expired-12"
        Then I should see "authentication token has expired"

    Scenario: No district support, multiple districts
        Given user "cuke_oneschool" with password "fr0d0L1v3s" exists
        And a district "other district"
        When I go to the home page
        And I press "Forgot Password"
        Then I should see "This district does not support password recovery"

    Scenario: Invalid user
        Given user "cuke_oneschool" with password "fr0d0L1v3s" exists
        And user has an email address
        And district has forgot_password
        When I go to the home page
        And I fill in "Login" with "not_cuke_oneschool"
        And I press "Forgot Password"
        Then I should see "User does not have email assigned in SIMS."

    Scenario: No email
        Given user "cuke_oneschool" with password "fr0d0L1v3s" exists
        And user has no email address
        And district has forgot_password
        When I go to the home page
        And I press "Forgot Password"
        Then I should see "User does not have email assigned in SIMS."

    Scenario: Forgot and change password
        Given user "cuke_oneschool" with password "fr0d0L1v3s" exists
        And user has an email address
        And district has forgot_password
        When I go to the home page
        And I fill in "Login" with "cuke_oneschool"
        And I press "Forgot Password"
        Then I should see "An email has been sent, follow the link to change your password."
        Then I should receive an email

        When I open the email

        Then I should see "change your password" in the email

        When I click the change_password link in the email
        Then I should see "Change password"

        And I should not see "Old password"
        And I fill in "Password" with "cucumber"
        And I fill in "Password confirmation" with "cucumber"
        And I press "Change password"

        Then I should see "Your password has been changed"

        And I should see "Please Login"
