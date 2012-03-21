Feature: School Teams
    In order to assign users to teams
    A School Admin
    Should be able to assign/remove users to teams

    Scenario: Manage Teams Page
        Given I am a school admin
        When I go to the home page
        Then I should see "Manage School Teams"

    Scenario: Not School Admin
        Given I am not a school admin
        When I go to the home page
        Then I should not see "Manage School Teams"


    Scenario: Create Team
        Given PENDING

    Scenario: Add Users to Team
        Given PENDING
        Given I am a school admin
        And there is a student in my group
        When I go to the home page
        And I follow "Manage Groups"
        And I follow "User and Student Assignment"
        Then I should see "Remove User"
        When I follow "Remove User"
        Then I should see "Add Student"
        And I should not see "Remove User"
