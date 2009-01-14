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
