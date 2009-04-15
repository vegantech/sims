Given /^I complete "Assign New Intervention"$/ do
  Given "I follow \"Select New Intervention and Progress Monitor from Menu\""
  Given "I select \"Some Goal\" from \"goal_definition_id\""
  Given "I press \"Choose Goal\""
  Given "I select \"Some Objective\" from \"objective_definition_id\""
  Given "I press \"Choose Objective\""
  Given "I select \"Some Category\" from \"intervention_cluster_id\""
  Given "I press \"Choose Category\""
  Given "I check \"Assign yourself to this intervention\""
  Given "I press \"Save\""
end
