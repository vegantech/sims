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

  Scenario: Change password
    Given user "cuke_oneschool" with password "fr0d0L1v3s" exists
    And I go to the home page
    Then I should not see "Change Password"

    When I fill in "Login" with "cuke_oneschool"
		And I fill in "Password" with "fr0d0L1v3s"
		And I press "Login"
    And I follow "Change Password"
  

    When I fill in "Old Password" with "wrong"
    And I press "Change Password"
    Then I should see "Your old password was incorrect"

    When I fill in "Old Password" with "fr0d0L1v3s"
    And I press "Change Password"
    Then I should see "Your password cannot be blank"

    When I fill in "Old Password" with "fr0d0L1v3s"
    And I fill in "Password" with "New"
    And I fill in "Password Confirmation" with "Something else"
    And I press "Change Password"
    Then I should see "Your password and confirmation must match"


    When I fill in "Old Password" with "fr0d0L1v3s"
    And I fill in "Password" with "New"
    And I fill in "Password Confirmation" with "New"
    And I press "Change Password"
    Then I should see "Your password has been changed"

    When I follow "Logout"
    And I fill in "Login" with "cuke_oneschool"
		And I fill in "Password" with "fr0d0L1v3s"
		And I press "Login"
    Then I should see "Please Login:"

    When I fill in "Password" with "New"
    And I press "Login"
    Then I should see "Logout"
