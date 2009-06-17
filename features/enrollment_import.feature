Feature: CSV Import of Enrollments
  In order to import enrollments for a district
  The System
  Should be able to import a file called enrollments.csv for a given district 

  Background:
    Given a district "Telophia"

  Scenario: Import enrollments csv with 1 change, 1 deletion, 1 insert and 1 noop
    Given a student "Bob Smith"
    And a school "Fish School"
    And enrollment "Bob Smith" in "Fish School" for grade "change_me"
    And enrollment "Bob Smith" in "Fish School" for grade "delete_me"
    And enrollment "Bob Smith" in "Fish School" for grade "noop"
    When I import_enrollments_from_csv with "test/csv/enrollments/telophia/enrollments.csv", "Telophia"
    Then "Bob Smith" has [change_me, insert_me, noop] for grades 
    And "Telophia" should have "3" enrollments
    #changing may not make sense since we're matching on all fields







# impact of deleting enrollments
# while delete is pending school selection would return no students accessible
# individual grade search on search screen would clear out other fields
# searching for anything would show no students
# picking a student when all enrollments deleted  "unauthorized student selected"

# Once selection is successful, impact is minimal,  enrollments simply do not show up on the profile


#csv:  student_id_district, school_id_district, grade

#enrollment: student_id, :school_id, :grade

################################
# Live updates, in place:
# 1- load all enrollments into memory in uploaded_enrollments


# uploaded_enrollments.each do |e|
#   if e.exists?({:student_id_district => e.student_id_district, :school_id_district => e.school_id_district, :grade => e.grade})
#     if e.changed?
#       to_update << e
#     end
#   else
#     to_add <<
#   end
#
# all_existing_enrollments.each do |ee|
#   unless ee.in_uploaded_enrollments
#     ee.destroy
#   end
# end
################################

#no and no, please actually think about this issue instead of stalling or deferring it.

################################s
#  Scenario: Import single user csv when all are new
#    When I import_users_from_csv with "test/csv/users/single/users.csv", "Telophia"
#    Then "Telophia" should have "2" users
#    And there should be a user with username "sally_smith"
#    And the command should have succeeded
#
#  Scenario: Import two users csv when one user already exists with changed password and one new
#    Given user "sally_smith" in district "Telophia" with password "big_bopper"
#    And User "sally_smith" should authenticate with password "big_bopper" for district "Telophia"
#    When I import_users_from_csv with "test/csv/users/two/users.csv", "Telophia"
#    Then User "sally_smith" should authenticate with password "little_bopper" for district "Telophia"
#    And "Telophia" should have "3" users
#    And there should be a user with username "sally_smith"
#    And the command should have succeeded
#
#  Scenario: Importing a file that does not exist
#    When I import_users_from_csv with "test/csv/does_not_exist.csv", "Telophia"
#    Then the command should have failed
#
#  Scenario: Importing an invalid file
#    When I import_users_from_csv with "test/users/invalid_format/users.csv", "Telophia"
#    Then the command should have failed
#    
#  Scenario: Import two user csv when all are new
#    When I import_users_from_csv with "test/csv/users/two/users.csv", "Telophia"
#    Then "Telophia" should have "3" users
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
#    When I import_users_from_csv with "test/csv/users/single/users.csv", "Telophia"
#    Then the command should have failed
#    # wiping out all the users is probably a bad csvdump
#    And "Telophia" should have "7" users
#
#
#  Scenario: Import very small csv when fewer than 6 records exist
#    #60% csv integrity threshold is not in play when 6 or fewer users exist in the district
#    Given user "sally_smith" in district "Telophia" with password "big_bopper"
#    Given user "bob_barker" in district "Telophia" with password "spay_or_neuter"
#    Given user "alan_alda" in district "Telophia" with password "mash"
#    Given user "charlie_chaplin" in district "Telophia" with password "the_great_dictatorr"
#    When I import_users_from_csv with "test/csv/users/single/users.csv", "Telophia"
#    Then the command should have succeeded
#    And "Telophia" should have "2" users
#
#    
#
#    
#    
#  
#
#
#
##(Constrained to a district)
##Import new users
##update existing
##remove ones not present (except where id_district is null)
#
#
#
