Feature: Manage roles
  In order to keep track of roles
  A role mechanic
  Should be able to manage several roles
  
  Scenario: Regular user cannot go to role page
    Given I am on the school selection page
    And I should not see "Role Management"
    When I enter URL "/roles/new"
    Then I should see "You are not authorized"

  Scenario: Register new role
    Given I am a district admin 
    And I am on the home page
#    Then I follow "Role Management"
#    And I follow "New role"
#    Then I Display Body
#    And I fill in "Name" with "New Role"
#    And I should see "students"
#    And I should see "read"
#    And I should see "write"
#    And I check "students_read"
#    And I check "schools_read"
#    And I check "schools_write"
#    And I press "Create"
#    Then I should see "Role New Role Created"

  Scenario: Delete role
#    Given there are 4 roles
#    When I delete the first role
#    Then there should be 3 roles left
    
#  More Examples:
#    | initial | after |
#    | 100     | 99    |
#    | 1       | 0     |

  Scenario: Edit role

  Scenario: View role

  Scenario: Assign users to role

  Scenario: Assign roles to user
