Feature: Student Maintenance
  In order to create/maintain students
  A SIMS district admin
  Should be able to create edit and remove students

  Scenario: Nondistrict admin should not see useradministration panel
    Given common data
    When I start at the school selection page
    Then I should not see "Add/Remove Students"

  Scenario: District admin should be able to add/create Students
    Given I am a district admin
    And a school in my district named "Glenn Stephens"
    When I start at the home page
    Then I follow "Add/Remove Students"
    Then I follow "New Student"
    Then I fill in "First name" with "George"
    And I fill in "Middle name" with "Freddie"
    Then I fill in "Last name" with "Harrelson"
    Then I fill in "Suffix" with "Jr IV"
    And I fill in "Grade" with "4"
    And I select "Glenn Stephens" from "School"
    Then I press "Create"
    Then I should not see "Create"
    And I should see "Harrelson"
    And I should see "Jr IV"

    Then I follow "Edit"
    And page should not contain "onblur"
    And the "Last name" field should contain "Harrelson"
    And the "Suffix" field should contain "Jr IV"

    And PENDING testing enrollment flags and extended profile

  Scenario: District admin attempts to enter a student that belongs to a district
    Given I am a district admin
    And student exists with id_state of 1234
    And I start at the home page
    Then I follow "Add/Remove Students"
    Then I follow "New Student"
    And I fill in "State ID" with "1234"
    #  And page source should contain "onblur"
    And I call ajax check_id_state with "1234"
    And PENDING this needs to be switched to jquery, or selenium
    Then I should see an alert
    When I enter url "/district/students/new"
    And I fill in "State ID" with ""
    And I call ajax check_id_state with ""
    Then I should not see an alert

  Scenario: District admin attempts to enter a student that does not belong to any district
    Given I am a district admin
    And student exists with no district and id_state of 1234
    And I start at the home page
    Then I follow "Add/Remove Students"
    Then I follow "New Student"
    And I fill in "State ID" with "1234"
    And I call ajax check_id_state with "1234"
    And PENDING this needs to be switched to jquery, or selenium
    # Then I should see a popup that the student was found
    Then I should see an alert
    And I should see "Claim First Last for your district"

  Scenario: Claim student
    Given I am a district admin
    And student exists with no district and id_state of 1234
    And I start at the home page
    And PENDING this needs to be switched to jquery, or selenium
    When I follow Claim First Last for your district
    Then I should see "Student First Last has been added to your district"
    And I should see "1234"

