Feature: Stat Generation/View
    In order to see usage metrics
    Anyone
    Should be able to see stats

    Scenario: View list
        When I enter url "/stats"
        Then I should see "Districts With Changes"
        And PENDING there should be more

    Scenario: View list exclude district
        When I enter url "/stats?without=2
        Then I should see "Districts With Changes"
        And PENDING there should be more
