Feature: Overall Student Report
  In order to See well organized information on a student
  As a user
  I want to see the student report

  Background:
    Given common data
    When I start at the the student profile page
    And I follow "Student Report"
    Then I should see "Choose Sections for Student Report Common Last"

  Scenario: Student with one consultation form owned directly by the student and one team consultation with a consultation form
    Given student "Common Last" directly owns consultation form with concern "1"
    When I check "Consultation Forms"
    And I press "Generate Report"
    And I should see "Strengths 1"
    And I should see "Concerns 1"
    And I should see "Recent changes 1"

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
