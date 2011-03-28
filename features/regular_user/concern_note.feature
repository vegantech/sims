Feature: Concern Note
  In order to facilitate team discussion and gather information
  A SIMS user
  Should be able to create concern notes, request and submit consultation forms

  Background:
    Given common data
    And I start at the student profile page

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
    Then I should see "Team Consultation Form" in the subject
    And I should see "A team consultation form has been generated for \(Common Last\) on" in the email
    And I should see "by \(default user\)" in the email
    And I should see "Please schedule an initial discussion at an upcoming team meeting" in the email

    When I follow "view"
    Then I should see "Strength"

  Scenario: Create Consultation Form as Response to Request
    Given I should not see "Respond to Request for Information"
    And Shawn Balestracci is a team contact for "Cucumber"
    When I follow "Create Team Consultation Form"
    #And I should see some sort of forma
    And I press "Save"
    When I follow "Respond to Request for Information"
    And I fill in "consultation_form_consultation_form_concerns_attributes_5_strengths" with "Spinach"
    And I press "Create"
#   this is js so I cannot test it
    Given I enter default student url
    When I follow "view" within "tr.consultation_form:last-of-type"
    Then I should see "Spinach"

