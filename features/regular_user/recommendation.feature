Feature: Student Recommendatins
	In order to use recommendatins
	A SIMS USER
	Should be able to use recommendations to increase the tier

  Background:
    Given Recommendations enabled

	Scenario: Viewing a recommendation
	Scenario: Creating an invalid recommendation
	Scenario: Creating a valid recommendation that increases the tier
	Scenario: Creating a valid recommendation that does not increase the tier
		Given I am at the student profile page
		When I create a valid recommendation that does not increase the tier
		Then I should be at the student profile page
                And I should see a summary of that recommendation
                And I follow "view"
	Scenario: Draft Recommendation
	Scenario: Edit recommendation
	Scenario: Delete recommendation
