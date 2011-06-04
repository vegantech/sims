Feature: School Groups
  In order to assign students and users to groups
  A School Admin
  Should be able to assign/remove users to virtual groups and users and students to groups

  Scenario: Manage Groups Page
    Given I am a school admin
    And there is a student in my group
    When I go to the home page
    Then I should see "Manage Groups"

  Scenario: Remove User from Group
    Given I am a school admin
    And there is a student in my group
    When I go to the home page
    And I follow "Manage Groups"
    And I follow "User and Student Assignment"
    Then I should see "Remove User"
    When I follow "Remove User"
    Then I should see "Add Student"
    And I should not see "Remove User"
    
