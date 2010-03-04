Feature Content Builder
  Scenario: content_builder
    Given load demo data
    And I go to the home page
    And I select "WI Test District" from "District"
    And I fill in "Login" with "content_builder"
    And I fill in "Password" with "content_builder"
    And I press "Login"
    And I follow "Flag Categories/Core Practices"
    And I follow "New Flag Category"
