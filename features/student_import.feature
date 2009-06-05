Feature: Import Students
  In order to use bulk import student data
  A SIMS DISTRICT ADMIN
  Should be able to upload a file to populate students in the district

  Scenario: Import a few students when none exist
    Given I am a district admin
    And I go to the home page

    And I show page
    
    And I follow "Add/Remove Students"
    And I follow "Bulk student import"
    And I attach the file at "features/support/3_students.csv" to "Students File"
    And I press "Import"
    Then I should see "Student Listing"
    Then there should be 3 students in the district


