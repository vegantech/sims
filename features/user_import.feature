Feature: CSV Import of Users
  In order to import users for a district
  The System
  Should be able to import a file called users.csv for a given district 

  Background:
    Given a district "Telophia"
    And no other users

  Scenario: Import empty csv when all are new
    When I import_users_from_csv with "test/csv/users/empty/users.csv", "Telophia"
    Then "Telophia" should have "0" user

  Scenario: Import single user csv when all are new
    When I import_users_from_csv with "test/csv/users/single/users.csv", "Telophia"
    Then "Telophia" should have "1" users
    And there should be a user with username "sally_smith"
    And the command should have succeeded

  Scenario: Import two users csv when one user already exists with changed password and one new
    Given user "sally_smith" in district "Telophia" with password "big_bopper"
    And User "sally_smith" should authenticate with password "big_bopper" for district "Telophia"
    When I import_users_from_csv with "test/csv/users/two/users.csv", "Telophia"
    Then User "sally_smith" should authenticate with password "little_bopper" for district "Telophia"
    And "Telophia" should have "2" users
    And there should be a user with username "sally_smith"
    And the command should have succeeded

  Scenario: Importing a file that does not exist
    When I import_users_from_csv with "test/csv/does_not_exist.csv", "Telophia"
    Then the command should have failed

  Scenario: Importing an invalid file
    When I import_users_from_csv with "test/users/invalid_format/users.csv", "Telophia"
    Then the command should have failed
    
  Scenario: Import two user csv when all are new
    When I import_users_from_csv with "test/csv/users/two/users.csv", "Telophia"
    Then "Telophia" should have "2" users
    And there should be a user with username "sally_smith"
    And there should be a user with username "bob_barker"
    And the command should have succeeded

  Scenario: Import very small csv when lots of records exist
    #60% csv integrity threshold.   Manual intervention or flag required when lines < District.model.count*.6 and District.model.count > 6
    Given user "sally_smith" in district "Telophia" with password "big_bopper"
    Given user "bob_barker" in district "Telophia" with password "spay_or_neuter"
    Given user "alan_alda" in district "Telophia" with password "mash"
    Given user "charlie_chaplin" in district "Telophia" with password "the_great_dictatorr"
    Given user "don_dieglo" in district "Telophia" with password "bree"
    Given user "ed_eisner" in district "Telophia" with password "disney"
    Given user "fred_flinstone" in district "Telophia" with password "barney"
    When I import_users_from_csv with "test/csv/users/single/users.csv", "Telophia"
    Then the command should have failed
    # wiping out all the users is probably a bad csvdump
    And "Telophia" should have "7" users


  Scenario: Import very small csv when fewer than 6 records exist
    #60% csv integrity threshold is not in play when 6 or fewer users exist in the district
    Given user "sally_smith" in district "Telophia" with password "big_bopper"
    Given user "bob_barker" in district "Telophia" with password "spay_or_neuter"
    Given user "alan_alda" in district "Telophia" with password "mash"
    Given user "charlie_chaplin" in district "Telophia" with password "the_great_dictatorr"
    When I import_users_from_csv with "test/csv/users/single/users.csv", "Telophia"
    Then the command should have succeeded
    And "Telophia" should have "1" users

    

    
    
  



#(Constrained to a district)
#Import new users
#update existing
#remove ones not present (except where id_district is null)



