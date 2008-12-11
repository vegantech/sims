Feature: Team Notes
  In order view team notes in batches
  A SIMS user
  Should be able to view Team Notes report
  
  Scenario: Show Team Notes
		Given team note "First Team Note" on "01/09/08"
		And team note "Second Team Note" on "01/10/08"
		And team note "Third Team Note" on "01/11/08"
		And team note "Fourth Team Note" on "01/12/08"
    And I go to the school selection page
    When I follow "Team Notes"
    And I select "January" from "start_date_month"
    And I select "10" from "start_date_day"
    And I select "2008" from "start_date_year"
    And I select "January" from "end_date_month"
    And I select "11" from "end_date_day"
    And I select "2008" from "end_date_year"
    And I press "Generate Report"
    Then I should see "Second Team Note"
    And I should see "Third Team Note"
    And I should not see "First Team Note"
    And I should not see "Fourth Team Note"
