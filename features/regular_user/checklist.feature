Feature: Student Checkist
  In order to use checklists
  A SIMS USER
  Should be able to view and create checklists

  Background:

  Scenario: Trying to view a checklist that does not exist
    Given I am at the student profile page
    When I try to view an invalid checklist
    Then I should be at the student profile page
    And I should see a notice for "Checklist no longer exists."
