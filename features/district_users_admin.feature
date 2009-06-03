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
    Then I fill in "Username" with "cuke_user"
    Then I fill in "First Name" with "Cuke"
    Then I fill in "Middle Name" with "Umber"
    Then I fill in "Last Name" with "User"
    And I fill in "Suffix" with "IV"
    Then I press "Create"
    Then I should see "Password can't be blank"
    Then I fill in "Password" with "cuke"
    Then I press "Create"
    Then I should see "Password doesn't match confirmation"
    Then I fill in "Password Confirmation" with "cuke"
    Then I press "Create"
    And I should see "Cuke U. User IV"
    When I follow "Edit"
    Then the "Middle" field should contain "Umber"
    And the "Suffix" field should contain "IV"
    Then I fill in "Username" with "cuke_user"
    Then I press "Update"
    Then I follow "Edit"
    Then I fill in "Username" with "unused_username_cuke"
    Then I press "Update"
    Then I should see "unused_username_cuke"
   

    
    

