Feature: Quicklist
    In order to assign intervention definitions to a quicklist
    A School Admin
    Should be able to add/remove intervention definitions to the quicklist

    Scenario: Quicklist menu item
        Given I am a school admin
        When I go to the home page
        Then I should see "Manage Quicklist"

    Scenario: Nonschooladmin
        Given I am not a school admin
        When I go to the home page
        Then I should not see "Manage Quicklist"

    Scenario: Add and remove from quicklist
        Given I am a school admin
        When I go to the home page
        And I follow "Manage Quicklist"
        And PENDING I check some boes and press submit
        Then I should see "quicklist updated"
        When I follow "Manage Quicklist"
        Then some boxes should be checked
        When I uncheck some boxes and press submit
        Then I should see "quicklist updated"
        When I follow "Manage Quicklist"
        Then no boxes should be checked
