Feature: Student Report
  In order to See well organized information on a student
  As an administrator
  I want to see the student report

  Background:
    Given common data
    When I am on the student profile page
    And I follow "Student Report"
    Then I should see "Choose Sections for Student Report Common Last"

  Scenario Outline: Section Checkboxes Trigger Section Display
    When I check "<label>"
    And I press "Generate Report"
    Then I should see "<header_or_unique_string>"
    Examples
     | label                | header_or_unique_string           |
     | Top summary          | Student Name:                     |
     | Flags                | Flags                             |
     | Team notes           | Team Notes                        |
     | Intervention summary | Student has no interventions      |
     | Consultation forms   | Student has no consultation forms |
   # | Checklists and/or recommendations | Checklists and Recommendations |
   # | Extended profile                  | ?                              |

  Scenario: Student Without Consultation Forms
    When I check "Consultation Forms"
    And I press "Generate Report"
    Then I should see "Student has no consultation forms"
    # When I show page
