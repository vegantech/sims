Feature: User Maintenance
  In order to create/maintain users
  A SIMS district admin
  Should be able to create edit and remove users
  
  Scenario: Nondistrict admin should not see useradministration panel
    Given common data
    When I go to the school selection page
    Then I should not see "Add/Remove Users" but am pending

  Scenario: District admin should be able to add/create Users
    Given I am a district admin
    And I go to the home page
    Then I follow "Add/Remove Users"
    Then I follow "New user"
    Then I am pending
    Then I fill in "Name" with "Cucumber Elementary"
    Then I press "Create"
    Then I should see "Cucumber Elementary"
    Then I follow "New School"
    Then I fill in "Name" with "Cucumber Elementary"
    Then I press "Create"
    Then I should see "Name has already been taken"
    Then I fill in "Name" with "Cucumber High"
    Then I press "Create"
    Then I follow "Edit"
    Then I fill in "Name" with "Cucumber High"
    Then I press "Update"
    Then I should see "Name has already been taken"
    Then I fill in "Name" with "Cucumber Middle"
    Then I press "Update"
    Then I should see "Cucumber Middle"


    
    

