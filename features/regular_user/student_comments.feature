Feature: Team Notes
  In order to make comments on a student
  A SIMS USER
  Should be able to add/edit/remove team notes

  Scenario: Try to add blank comment to a student
  Given I am at the student profile page
  And I follow "Add Note"
  And I press "Save"
  Then I should see "Body or attachment is required"

  Scenario: Try to edit blank comment for a student
  Given there is a comment by me
  Given I am at the student profile page
  And I follow "Add Note"
  And I fill in "Note" with ""
  And I press "Save"
  Then I should see "Body or attachment is required"



  Scenario: Add a comment to a student
  Given I am at the student profile page
  When I add a team note
  Then I should see the note on the student profile page

  @allow-rescue
  Scenario: Try to edit someone elses comment
  Given there is a comment not by me
  When I am at the student profile page
  Then I should not see "Edit"
  When I try to edit the comment anyway
  Then it should not work

  @allow-rescue
  Scenario: Try to delete someone elses comment
  Given there is a comment not by me
  When I am at the student profile page
  Then I should not see "Delete"
  When I try to delete the comment anyway
  Then I should see "Show/Hide Team Notes (1)"

  Scenario: Deleting my comment
  Given there is a comment by me
  And I am at the student profile page
  When I follow Delete
  Then I should not see my comment

  Scenario: Editing my comment
  Given there is a comment by me
  And I am at the student profile page
  When I edit the comment
  Then I should see the note on the student profile page
