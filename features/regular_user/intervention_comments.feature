Feature: Intervention COmments
  In order to make comments on intervention progress
  A SIMS USER
  Should be able to make comments on interventions

  Scenario: Add a comment to an intervention that someone else created #659
  Given there is an intervention by another user
  And I am at the student profile page
  When I edit that intervention and add a comment
  And view that intervention again
  Then I should see the comment was made by me
