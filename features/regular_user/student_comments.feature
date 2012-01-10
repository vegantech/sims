Feature: Team Notes
  In order to make comments on a student
  A SIMS USER
  Should be able to add/edit/remove team notes

  Scenario: Try to add blank comment to a student
  Given I am at the student profile page
  And I follow "Add Note"
  And I press "Save"
  Then I should see "Body can't be blank"

  Scenario: Add a comment to a student
  Given I am at the student profile page
  When I add a team note
  Then I should see the note on the student profile page
