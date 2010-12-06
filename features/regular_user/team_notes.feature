Feature: Team Notes
  In order view team notes in batches
  A SIMS user
  Should be able to view Team Notes report

  Scenario: Show Team Notes
    Given common data
		And team note "First Team Note" on "01/09/08"
		And team note "Second Team Note" on "01/10/08"
		And team note "Third Team Note" on "01/11/08"
		And team note "Fourth Team Note" on "01/12/08"
    And other district team note "Fifth Team Note" on "01/11/08"
    And other school team note "Sixth Team Note" on "01/11/08"
    And unauthorized student team note "Seventh Team Note" on "01/11/08"
    And I start at the school selection page
#    And I select "Default School" from "school_id"
#    And I press "Choose School"
    When I follow "Team Notes"
    And I select "January" from "start_date-mm"
    And I select "10" from "start_date-dd"
    And I select "2008" from "start_date"
    And I select "January" from "end_date-mm"
    And I select "11" from "end_date-dd"
    And I select "2008" from "end_date"
    And I press "Generate Report"
    Then I should see "Second Team Note"
    And I should see "Third Team Note"
    And I should not see "First Team Note"
    And I should not see "Fourth Team Note"
    And I should not see "Fifth Team Note"
    And I should not see "Sixth Team Note"
    And I should not see "Seventh Team Note"
    When I follow "Common Last"
    Then I should see "Intervention and Progress Monitoring"
    And I should see "Last, Common"
