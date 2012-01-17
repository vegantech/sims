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

  Scenario: Trying to view a checklist that does exist
    Given a completed checklist
    And I am at the student profile page
    When I view the checklist
    Then I should see the completed checklist

  Scenario: Editing a checklist
    Given a completed checklist
    And I am at the student profile page
    When I edit the checklist
    Then I should be at the student profile page
    When I view the checklist
    Then I should see the completed checklist


  Scenario: Removing a checklist

  Scenario: Creating a new checklist

  Scenario: Attempting to create a new checklist after first creating a draft



