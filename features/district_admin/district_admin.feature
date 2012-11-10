Feature: District Admin
  In order to manage districts or their own
  A District Admin
  Should be able edit their district and add/create others if they are the state admin

  Scenario: District Admin of State District
    Given I am a state admin
    And I go to the home page
#    Then I should see "Manage Districts"
    When I enter url "/districts"
    Then I should see "New District"


  Scenario: District Admin of Normal District
    Given I am a district admin
    And I go to the home page
    Then I should not see "Add/Remove Districts"
    When I enter url "/districts"
    Then I should not see "New District"


  Scenario:  test district_admin
    Given load demo data
    And I go to the home page
    And I select "WI Test District" from "District"
    And I fill in "Login" with "district_admin"
    And I fill in "Password" with "district_admin"
    Then I press "Login"
    And I should see "Change your logo and url"
    And I follow "Change your logo and url"
    And I should not see "Sorry, help not found."
    And I follow "Home"
    And I should see "New news_item"
    And I should see "WI Test District Administration"
    And I should see "Add/Remove Users"
    And I should see "Add/Remove Students"
    And I should see "Edit your district"
    And I should see "Add/Remove Schools"

  #Edit User
    When I follow "Add/Remove Users"
    When I follow "Edit" within "#tr_659073605"
    Then I should see "Editing user"
    Then I press "Update"

  # lighthouse ticket 158 editing a second time causes a validation error
    When I follow "Edit" within "#tr_659073605"
    Then I should see "Editing user"
    Then I press "Update"

  Scenario: Edit your district District
    Given I am a district admin
    When I go to the home page
    And I follow "Edit your district"
    Then I should see "Custom interventions"

  Scenario: Edit your district settings
    Given I am a district admin
    When I go to the home page
    And I follow "Edit your district"
    And I uncheck all district_settings boxes
    And I press "Update"
    Then all boolean district settings should be false
    When I follow "Edit your district"
    And I check all district_settings boxes
    And I fill in "Google apps domain" with "whatever"
    And I press "Update"
    Then all boolean district settings should be true
    When I follow "Edit your district"
    And I uncheck all district_settings boxes
    And I press "Update"
    Then all boolean district settings should be false
