Given /^Create Custom Probe$/ do

  @o={"end_date(3i)"=>"26", "start_date(1i)"=>"2009", "apply_to_all"=>"0", "start_date(2i)"=>"4", "auto_implementer"=>"0", "intervention_probe_assignment"=>{"end_date(3i)"=>"26", "probe_definition_id"=>"", "probe_definition_attributes"=>{"title"=>"custom_probe_title", "minimum_score"=>"1", "description"=>"custom_probe_desc", "probe_definition_benchmarks_attributes"=>{"e_"=>{"benchmark"=>"200", "grade_level"=>"1"}}, "maximum_score"=>"50"}, "frequency_multiplier"=>"2", "first_date(1i)"=>"2009", "first_date(2i)"=>"4", "frequency_id"=>"284292352", "first_date(3i)"=>"27", "end_date(1i)"=>"2009", "end_date(2i)"=>"7"}, "start_date(3i)"=>"27", "frequency_multiplier"=>"1", "intervention_definition_attributes"=>{"title"=>"int_def_title", "description"=>"int_def_desc", "tier_id"=>"284451385", "intervention_cluster_id"=>"909549077"}, "time_length_id"=>"503752779", "user_id"=>193973844, "frequency_id"=>"284292352", "selected_ids"=>["310913251", "22766020"], "comment"=>{"comment"=>""}, "end_date(1i)"=>"2009", "time_length_number"=>"1", "school_id"=>296151536, "end_date(2i)"=>"7", "student_id" => "310913251"}
  @i=Intervention.build_and_initialize(@o)

end

Then /^it should not save$/ do
  @i.save.should == false
end

Then /^it should save when fixed$/ do
  @i.intervention_probe_assignment.probe_definition.maximum_score=200
  @i.save.should == true
end

