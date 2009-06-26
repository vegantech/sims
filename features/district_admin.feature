Feature: District Admin
  In order to manage districts or their own
  A District Admin
  Should be able edit their district and add/create others if they are the state admin

  Scenario: District Admin of State District
    Given I am a state admin
    And I go to the home page
#    Then I should see "Manage Districts"
    When I enter url "/districts"
    Then I should see "New district"
    


  Scenario: District Admin of Normal District
    Given I am a district admin
    And I go to the home page
    Then I should not see "Add/Remove Districts"
    When I enter url "/districts"
    Then I should not see "New district"


