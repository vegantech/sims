Feature: Forgot Password
    In order to recover a lost password
    A SIMS user
    Should be able to recover their password by email

    Scenario: District with forgot password disabled
        Given user "cuke_oneschool" with password "fr0d0L1v3s" exists
        When I go to the home page
        Then I should not see "Forgot Password" within "#new_user"

    Scenario: Expired Token
        Given user "cuke_oneschool" with password "fr0d0L1v3s" exists
        And user has an email address
        And district has forgot_password
        And user has expired token
        When I am at the recovery_url
        And I fill in "New password" with "cucumber"
        And I fill in "Confirm new password" with "cucumber"
        And I press "Change my password"
        Then I should see "Reset password token has expired, please request a new one"

    Scenario: Old email with valid Token
        Given user "cuke_oneschool" with password "fr0d0L1v3s" exists
        And user has an email address
        And district has forgot_password
        And user has expired token
        When I am at the old recovery_url
        Then I should see "Reset password token has expired, please request a new one"


    Scenario: No district support, multiple districts
        Given user "cuke_oneschool" with password "fr0d0L1v3s" exists
        And a district "other district"
        And user has an email address
        When I go to the home page
        And I pick my district
        And I fill in "Login" with "cuke_oneschool"
        And I press "Forgot Password?"
        Then I should see "This district does not support password recovery"

    Scenario: Invalid user
        Given user "cuke_oneschool" with password "fr0d0L1v3s" exists
        And user has an email address
        And district has forgot_password
        When I go to the home page
        And I fill in "Login" with "not_cuke_oneschool"
        And I press "Forgot Password?"
        Then I should see "Username not found"

    Scenario: No email
        Given user "cuke_oneschool" with password "fr0d0L1v3s" exists
        And user has no email address
        And district has forgot_password
        When I go to the home page
        And I fill in "Login" with "cuke_oneschool"
        And I press "Forgot Password?"
        Then I should see "User does not have email assigned in SIMS."

    Scenario: Forgot and change password
        Given user "cuke_oneschool" with password "fr0d0L1v3s" exists
        And user has an email address
        And district has forgot_password
        When I go to the home page
        And I fill in "Login" with "cuke_oneschool"
        And I press "Forgot Password?"
        Then I should see "An email has been sent, follow the link to change your password."
        Then I should receive an email

        When I open the email

        Then I should see "change your password" in the email

        When I click the change_password link in the email
        Then I should see "Change your password"

        And I fill in "New password" with "cucumber"
        And I fill in "Confirm new password" with "cucumber"
        And I press "Change my password"

        Then I should see "Your password was changed successfully. You are now signed in"
