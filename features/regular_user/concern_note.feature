Feature: Concern Note
  In order to facilitate team discussion and gather information
  A SIMS user
  Should be able to create concern notes, request and submit consultation forms

  Background:
    And I am at the student profile page

  Scenario: Create Team Consultation Form without any teams
    When I follow "Create Team Consultation Form"
    Then I should see "A form cannot be assigned for this schol until a school admin assigns teams."


  Scenario: Create Team Consultation Form
    Given Shawn Balestracci is a team contact for "Cucumber"
    When I follow "Create Team Consultation Form"
    #And I should see some sort of forma
    And I press "Save"
    Then I should see "The concern note has been sent to Cucumber."
    And I should see "A discussion about this student will occur at an upcoming team meeting."
    And I should receive an email
    When I open the email
    Then I should see "Team Consultation Form Created -- Cucumber" in the email subject
    And I should see "A team consultation form has been generated for \(Cucumber Student\) on" in the email
    And I should see "by \(Cucumber Last_Name\)" in the email
    And I should see "Please schedule an initial discussion at an upcoming \(Cucumber\) team meeting" in the email
    And I go to the cucumber student profile page

    When I follow "view"
    Then I should see "Strength"

  Scenario: Create Consultation Form as Response to Request
    Given I should not see "Respond to Request for Information"
    And Shawn Balestracci is a team contact for "Cucumber"
    When I follow "Create Team Consultation Form"
    #And I should see some sort of forma
    And I press "Save"
    And I go to the cucumber student profile page
    When I follow "Respond to Request for Information"
    And I fill in "consultation_form_consultation_form_concerns_attributes_5_strengths" with "Spinach"
    And I press "Create"
    And I go to the cucumber student profile page
    When I follow "view" within "tr.consultation_form:last-of-type"
    Then I should see "Spinach"

	Scenario: Send email on team consultation response
		Given Shawn Balestracci is a team contact for "Cucumber"
		And I follow "Create Team Consultation Form"
		And I press "Save"
		And a clear email queue
		When The district is not set to email on responses
		And I go to the cucumber student profile page
		When I follow "Respond to Request for Information"
		And I fill in "consultation_form_consultation_form_concerns_attributes_5_strengths" with "Spinach"
		And I press "Create"
		Then I should receive no emails
		When The district is set to email on responses
		And I go to the cucumber student profile page
		When I follow "Respond to Request for Information"
		And I fill in "consultation_form_consultation_form_concerns_attributes_5_strengths" with "Spinach"
		And I press "Create"
		Then I should receive an email
		When I open the email
		Then I should see "Team Consultation Form Response -- Cucumber" in the email subject

	Scenario: Display or Hide the Team Consultations Section
		Given Shawn Balestracci is a team contact for "Cucumber"
		When I reload the team consultation based on the following table:
			| setting        | consultation? | display? |
			| false          | open          | false    |
			| true           | open          | true     |
			| true           | draft         | true     |
			| true           | other_draft   | false    |
			| true           | none          | false    |
