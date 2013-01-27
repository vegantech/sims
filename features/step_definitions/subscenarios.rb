Given /^I complete "Assign New Intervention"$/ do
  step "I follow \"Select New Intervention and Progress Monitor from Menu\""
  step "I select \"Some Goal\" from \"goal_definition_id\""
  step "I press \"Choose Goal\""
  step "I select \"Some Objective\" from \"objective_definition_id\""
  step "I press \"Choose Objective\""
  step "I select \"Some Category\" from \"intervention_cluster_id\""
  step "I press \"Choose Category\""
  step "I check \"Assign yourself to this intervention\""
  step "I press \"Save\""
end
