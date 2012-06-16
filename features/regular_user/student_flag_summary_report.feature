Feature: Team Notes
    In order view a report of flaged students
    A SIMS user
    Should be able to view student flags

    Background:
        Given clear login dropdowns

    Scenario: No flags
        Given common data
        And I start at the student profile page
        When I follow "Flagged Students"

    Scenario: Some Flags
        Given PENDING DO This

