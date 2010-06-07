Feature: CSV Import of Students
  In order to import students for a district
  The System
  Should be able to import a file called students.csv for a given district 

  Background:
    Given a district "Telophia"


  Scenario: Import student where id_state is not in system
    Given no other students
    When I import_csv with "test/csv/students/single/students.csv"
    Then the command should have succeeded
    And there should be "1" student

		When I remove the student and state_id
    And I import_csv with "test/csv/students/no_id_state/students.csv"
		And the command should have "1 students claimed that had left another district"

    And there should be "1" student


  Scenario: Import students with varying ESL/birthdate to confirm truthiness
    Given no other students
    When I import_csv with "test/csv/students/bool/students.csv"
    Then all students with last name "FALSE" should be "false"
    Then all students with last name "TRUE" should be "true"
    

  Scenario: Import where student is deleted and have no other tables referencing them
    Given no other students
    Given a student "Ignored Parameter"
    When I import_csv with "test/csv/students/empty/students.csv"
    Then the command should have succeeded
    And there should be "0" students
  #  Then it should delete the student (not destroy, and this should be done in bulk)  #also for district admin builder

  Scenario: Import where student is deleted but has tables referencing them
    Given no other students
    And a student "Ignored Parameter"
    And the system should have "0" students not assigned to districts
    And enrollment "Ignored Parameter" in "Ignored Parameter" for grade "change_me"
    When I import_csv with "test/csv/students/empty/students.csv"
    Then the command should have succeeded
    And there should be "0" students
    And the system should have "1" students not assigned to districts

    #Then it should set the id_district to nil (again a bulk update_all)  #also for district_admin builder



    #what if enrollment exists?  Is that an exception to this, if so, how do we remove the enrollment?
  




#  Scenario: Import student where id_state is in another district
#    Then It should fail and spit out a message

#  Scenario: Import student where id_state is in a nil distict
#    Then it should update the student and set the district_id

#  Scenario: Import where student is in the district
#    Then it should update the student






#  Scenario: Import empty csv when all are new
#    When I import_students_from_csv with "test/csv/students/empty/students.csv", "Telophia"
#    Then "Telophia" should have "1" student
#
#  Scenario: Import single student csv when all are new
#    When I import_students_from_csv with "test/csv/students/single/students.csv", "Telophia"
#    Then "Telophia" should have "2" students
#    And there should be a user with username "sally_smith"
#    And the command should have succeeded
#
#  Scenario: Import two students csv when one user already exists with changed password and one new
#    Given user "sally_smith" in district "Telophia" with password "big_bopper"
#    And User "sally_smith" should authenticate with password "big_bopper" for district "Telophia"
#    When I import_users_from_csv with "test/csv/students/two/students.csv", "Telophia"
#    Then User "sally_smith" should authenticate with password "little_bopper" for district "Telophia"
#    And "Telophia" should have "3" students
#    And there should be a user with username "sally_smith"
#    And the command should have succeeded
#
#  Scenario: Importing a file that does not exist
#    When I import_users_from_csv with "test/csv/does_not_exist.csv", "Telophia"
#    Then the command should have failed
#
#  Scenario: Importing an invalid file
#    When I import_users_from_csv with "test/students/invalid_format/students.csv", "Telophia"
#    Then the command should have failed
#    
#  Scenario: Import two user csv when all are new
#    When I import_users_from_csv with "test/csv/students/two/students.csv", "Telophia"
#    Then "Telophia" should have "3" students
#    And there should be a user with username "sally_smith"
#    And there should be a user with username "bob_barker"
#    And the command should have succeeded
#
#  Scenario: Import very small csv when lots of records exist
#    #60% csv integrity threshold.   Manual intervention or flag required when lines < District.model.count*.6 and District.model.count > 6
#    Given user "sally_smith" in district "Telophia" with password "big_bopper"
#    Given user "bob_barker" in district "Telophia" with password "spay_or_neuter"
#    Given user "alan_alda" in district "Telophia" with password "mash"
#    Given user "charlie_chaplin" in district "Telophia" with password "the_great_dictatorr"
#    Given user "don_dieglo" in district "Telophia" with password "bree"
#    Given user "ed_eisner" in district "Telophia" with password "disney"
#    When I import_users_from_csv with "test/csv/students/single/students.csv", "Telophia"
#    Then the command should have failed
#    # wiping out all the students is probably a bad csvdump
#    And "Telophia" should have "7" students
#
#
#  Scenario: Import very small csv when fewer than 6 records exist
#    #60% csv integrity threshold is not in play when 6 or fewer students exist in the district
#    Given user "sally_smith" in district "Telophia" with password "big_bopper"
#    Given user "bob_barker" in district "Telophia" with password "spay_or_neuter"
#    Given user "alan_alda" in district "Telophia" with password "mash"
#    Given user "charlie_chaplin" in district "Telophia" with password "the_great_dictatorr"
#    When I import_users_from_csv with "test/csv/students/single/students.csv", "Telophia"
#    Then the command should have succeeded
#    And "Telophia" should have "2" students
