Feature: Student Report
  In order to See well organized information on a student
  As an administrator
  I want to see the student report

  Background:
    Given common data
    When I am on the student profile page
    And I follow "Student Report"
    Then I should see "Choose Sections for Student Report Common Last"

  Scenario: Student with one consultation form owned directly by the student and one team consultation with a consultation form
    Given student "Common Last" directly owns consultation form for date "2009-05-26" with concern "1"
    When I check "Consultation Forms"
    And I press "Generate Report"
    Then I should see "2009-05-26"
    And I should see "Strengths 1"
    And I should see "Concerns 1"
    And I should see "Recent changes 1"
    And I show page

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
   # | Extended profile                  | ?  What should we be seeing ?? |

  Scenario: Student Without Consultation Forms
    When I check "Consultation Forms"
    And I press "Generate Report"
    Then I should see "Student has no consultation forms"
