Feature: Student Report
  In order to See well organized information on a student
  As an administrator
  I want to see the student report

  Scenario: Student Report Includes Consultation Form
    Given common data
    When I am on the student profile page
    And I follow "Student Report"
    Then I should see "Choose Sections for Student Report Common Last"
    When I check "Consultation Forms"
    And I press "Generate Report"
    Then I should see "Student Name:"
    And I should see "Last, Common"
    And I should see "School:"
    And I should see "Default School"
    And I should see "Student has no interventions"
    # When I show page
