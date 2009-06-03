Feature: Student Maintenance
  In order to create/maintain students
  A SIMS district admin
  Should be able to create edit and remove students
  
  Scenario: Nondistrict admin should not see useradministration panel
    Given common data
    When I go to the school selection page
    Then I should not see "Add/Remove Students"

  Scenario: District admin should be able to add/create Students
    Given I am a district admin
    And I go to the home page
    Then I follow "Add/Remove Students"
    Then I follow "New Student"
    Then I fill in "First Name" with "George"
    And I fill in "Middle Name" with "Freddie"
    Then I fill in "Last Name" with "Harrelson"
    Then I fill in "Suffix" with "Jr IV"
    Then I press "Create"
    Then I should not see "Create"
    And I should see "Harrelson"
    And I should see "Jr IV"
    When I follow "Back"
    And I should see "Harrelson"
    And I should see "Jr IV"
    
    Then I follow "Edit"
    And the "Last name" field should contain "Harrelson"
    And the "Suffix" field should contain "Jr IV"

    And pending testing enrollment flags and extended profile
