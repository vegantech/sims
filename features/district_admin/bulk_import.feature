Feature: Import CSV
  In order to use bulk import student and other data
  A SIMS DISTRICT ADMIN
  Should be able to upload a file to populate data in the district

  Scenario: Import users from a users.csv
    Given I am a district admin
    And I go to the home page
    And I follow "Import from CSV"
    And I attach the file "features/support/files/users.csv" to "File to Import"
    And I press "Import"
    Then I should see "Successful import of users.csv"
    Then there should be 4 users in the district


