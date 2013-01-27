Feature: CSV Import of Extended Profiles
  In order to import extended profiles for students in a district
  The System
  Should be able to import extended_profiles.zip, or individual arbitraries.csv, or reverses.csv for a given district

  Background:
    Given a district "Telophia"

  Scenario: Import empty csv when all are new
    When I import_extended_profiles_from_csv with "test/csv/extended_profiles/empty/ext_arbitraries.csv", "Telophia"
    And PENDING I am Pending
    Then "Telophia" should have "0" extended profiles

  Scenario: Import single extended_profile csv when all are new
    Given no other students
    Given a student "Sammy Homework"
    When I import_extended_profiles_from_csv with "test/csv/extended_profiles/single/ext_arbitraries.csv", "Telophia"
    Then "Telophia" should have "1" extended profiles
    And there should be an extended_profile for student "Sammy Homework"
    And the command should have succeeded

