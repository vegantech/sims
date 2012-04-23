Feature: Search By Student Groups
  In order to pick students to manage
  A SIMS user
  Should be able to find students by Student Group criteria

	Background:
		Given clear login dropdowns

  Scenario: User With One Group
    Given school "Central"
    And group "Blue Team" for school "Central" with student "Blue Floyd"
    And group "Red Team" for school "Central" with student "Red Fred"
    And I have access to "Blue Team"
    And I start at the search page

    # And I should see my own username in the group member selection
    # And group_member_selection_id drop down should contain ["Prompt", "Option 1", "Option 2"]
    # And user_id drop down should contain ["default_user"]
    # And I should see select box with id of "search_criteria_user_id" and contains ['First Last']
    And I should see select box with id of "search_criteria_group_id" and contains ['Blue Team']

    # Then I should see Blue Team selection option
    # And I should not see Red team selection option
    When I select "Blue Team" from "Student Group"
    And I press "Search for Students"

    Then I should see "Floyd, Blue"
    And I should not see "Fred, Red"

  Scenario: User With Two Groups Picks One
    Given school "East High"
    And group "Orange Team" for school "East High" with student "Alfie Orange"
    And group "Maroon Team" for school "East High" with student "Harold Yerbie"
    And I have access to "Orange Team"
    And I have access to "Maroon Team"
    And I start at the search page
    And I should see select box with id of "search_criteria_group_id" and contains ['Filter by Group','Maroon Team', 'Orange Team']
    When I select "Orange Team" from "Student Group"
    And I press "Search for Students"
    Then I should see "Orange, Alfie"
    And I should not see "Yerbie, Harold"



  Scenario: User with Two groups picks one shared by another user Lighthouse 209
    Given school "Central"
    And group "Blue Team" for school "Central" with student "Blue Floyd" in grade "1"
    And group "Red Team" for school "Central" with student "Red Fred" in grade "3"
    And group "Yellow Team" for school "Central" with student "Yellow Mellow" in grade "3"
    And group "Green Team" for school "Central" with student "Green Gene" in grade "3"
    And I have access to ["Blue Team","Red Team", "Yellow Team", "Green Team"]
    And "Other_Guy" has access to ["Blue Team", "Yellow Team", "Green Team"]
    And I start at the search page
    And I should see select box with id of "search_criteria_group_id" and contains ["Filter by Group","Blue Team", "Green Team","Red Team", "Yellow Team"]
    And I should see select box with id of "search_criteria_user_id" and contains ["All Staff","Other Guy","default user"]
    And I should see select box with id of "search_criteria_grade" and contains ["*", "1", "3"]

    When I select "3" from "search_criteria_grade"
    And I select "Other Guy" from "search_criteria_user_id"
    And I select "Yellow Team" from "search_criteria_group_id"
    Then I press "Search for Students"
    Then I should see "Mellow, Yellow"
    Then I should not see "Fred, Red"


  Scenario: User with two groups, changes member  grade 3
    Given school "Central"
    And group "Blue Team" for school "Central" with student "Blue Floyd" in grade "3"
    And group "Red Team" for school "Central" with student "Red Fred" in grade "1"
    And I have access to ["Blue Team","Red Team"]
    And "Other_Guy" has access to ["Blue Team"]
    And I start at the search page
    And I should see select box with id of "search_criteria_group_id" and contains ["Filter by Group","Blue Team", "Red Team"]
    And I should see select box with id of "search_criteria_user_id" and contains ["All Staff","Other Guy", "default user"]
    And I should see select box with id of "search_criteria_grade" and contains ["*", "1", "3"]

    And I should see javascript code that will do xhr for "search_criteria_user_id" that updates ["search_criteria_group_id"]
    And I select "3" from "search_criteria_grade"
    #and I ignore the rjs call
    When I select "Other Guy" from "search_criteria_user_id"
    And xhr "search_criteria_user_id" updates ["search_criteria_group_id"]
    Then I should verify rjs has options ["Blue Team"]






#test student group dropdown
# 0 all (2 exist) groups available to user (show * + 2 options in dropdown)   should be able to see ungrouped
# 1 group available to user (user with one group above) should not beable to see ungrouped   readonly
# 2 groups available to user (choose) show * as well should not be able t osee ungrouped, but should be able to pick all their groups 


#general policy dropdowns, don't allow users to choose if they have no choice, or the choices have no difference
# 


# Scenarios -- group member
# 
#   -- one group user
#   group member has 1 row,     it should possibly be disabled
#           student groups should be assigned to that group member
# 
#   -- two+ groups user not all groups
#     group member has >1 rows,  it should also have a * to represent all available groups for that user
#           student groups should be the superset of listed groups
# 
# 
#   -- all group user
#       group member should have all users explicitly assigned to groups for school, should have * to represent all school groups.
#       student groups should be all in school.
# 
# 
#    user has access to no groups
#       ???  it should do something else maybe prompt them to add a group or contact support
#       
#   In both cases, the * represents all the user's groups,   which will be determined through the model and special groups.
#   
# 
# 
# student groups
#     * should be all groups available to member and only present if student groups has more than one


# other scenario all students by grade in school
#   should be empty or * if only explicit group available
#   otherwise explicit groups (with *)
