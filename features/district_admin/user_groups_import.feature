Feature: CSV Import of UserGroups
  In order to import user group assignments for a district
  The System
  Should be able to import a file called groups.csv for a given district 

  Background:
    Given a district "Telophia"
    And no other groups

  Scenario: Import groups csv with 1 change, 1 deletion, 1 insert and 1 noop
    And I am pending
    Given a school "Fish School"
    And group "No Change" for school "Fish School" with id_district "neih1"
    And group "Should Delete" for school "Fish School"
    And group "Old B" for school "Fish School" with id_district "grp2"
    When I import_csv with "test/csv/groups/telophia/groups.csv"
    Then the command should have succeeded
#    Then I show groups
    Then "Fish School" should have "3" groups
    And "Fish school" should have groups ["Group A", "Group B", "No Change"]
    # changing may not make sense since we're matching on all fields

