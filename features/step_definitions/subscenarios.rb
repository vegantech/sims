Given /^I complete "Assign New Intervention"$/ do
  run_step "I follow \"Select New Intervention and Progress Monitor from Menu\""
  run_step "I select \"Some Goal\" from \"goal_definition_id\""
  run_step "I select \"Some Goal\" from \"goal_definition_id\""
  run_step "I press \"Choose Goal\""
  run_step "I select \"Some Objective\" from \"objective_definition_id\""
  run_step "I press \"Choose Objective\""
  run_step "I select \"Some Category\" from \"intervention_cluster_id\""
  run_step "I press \"Choose Category\""
  run_step "I check \"Assign yourself to this intervention\""
  run_step "I press \"Save\""
end

