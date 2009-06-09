Feature: CSV Import of Users
  In order to import users for a district
  The System
  Should be able to import a file called users.csv for a given district 

  Background:
    Given a district "Telophia"

  Scenario: Import empty csv when all are new
    When I import_users_from_csv with "test/csv/empty_users.csv", "Telophia"
    Then "Telophia" should have "1" user
    And the command should have succeeded

  Scenario: Import single user csv when all are new
    When I import_users_from_csv with "test/csv/single_user.csv", "Telophia"
    Then "Telophia" should have "2" users
    And there should be a user with username "sally_smith"
    And the command should have succeeded

  Scenario: Import single user csv when user already exists and a changed password
    Given user "sally_smith" in district "Telophia" with password "big_bopper"
    And User "sally_smith" should authenticate with password "big_bopper" for district "Telophia"
    When I import_users_from_csv with "test/csv/single_user.csv", "Telophia"
    Then User "sally_smith" should authenticate with password "little_bopper" for district "Telophia"
    And "Telophia" should have "2" users
    And there should be a user with username "sally_smith"
    And the command should have succeeded

  Scenario: Importing a file that does not exist
    When I import_users_from_csv with "test/csv/does_not_exist.csv", "Telophia"
    Then the command should have failed

  Scenario: Importing an invalid file
    When I import_users_from_csv with "test/csv/invalid_format.csv", "Telophia"
    Then the command should have failed
    
  Scenario: Import two user csv when all are new
    When I import_users_from_csv with "test/csv/two_users.csv", "Telophia"
    Then "Telophia" should have "3" users
    And there should be a user with username "sally_smith"
    And there should be a user with username "bob_barker"
    And the command should have succeeded
    
    
  



#(Constrained to a district)
#Import new users
#update existing
#remove ones not present (except where id_district is null)



