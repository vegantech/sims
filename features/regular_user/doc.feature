Feature: Documentation Generation/View
  In order to see generated documentationmaintain security of protected data
  Anyone
  Should be able to see a list of documentation
  
  Scenario: View list
    When I enter url "/doc"
    Then I should see "District Upload API"

  Scenario: District Upload
    When I enter url "/doc"
    And I follow "District Upload API"
    Then I should see "examples.csv"

    



