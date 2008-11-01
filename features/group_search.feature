Feature: Search By Student Groups
  In order to pick students to manage
  A SIMS user
  Should be able to find students by Student Group criteria
  
  Scenario: User With One Group
    Given school "Central"
    And group "Blue Team" for school "Central" with student "Blue Floyd"
    And group "Red Team" for school "Central" with student "Red Fred"
    And I have access to "Blue Team"
    When I am on search page

    # And I should see my own username in the group member selection
    # And group_member_selection_id drop down should contain ["Prompt", "Option 1", "Option 2"]
    # And user_id drop down should contain ["default_user"]
    # And I should see read only select box with id of "search_criteria_user_id" and contains ['First Last']
    And I should see select box with id of "search_criteria_group_id" and contains ['Blue Team']

    # Then I should see Blue Team selection option
    # And I should not see Red team selection option
    And I select "Blue Team" from "Student Group"
    And I press "Search for Students"
    And I should see "Floyd, Blue"
    And I should not see "Fred, Red"

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


