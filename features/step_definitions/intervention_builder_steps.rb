Given /^there is an intervention_definition that is "([^\"]*)" and "([^\"]*)"$/ do |enabled, custom|
  if InterventionDefinition.count >0
    od = InterventionDefinition.first.intervention_cluster
    i=Factory(:intervention_definition, :title => "#{enabled.capitalize} #{custom.capitalize}", :intervention_cluster => od)
  else
    i=Factory(:intervention_definition, :title => "#{enabled.capitalize} #{custom.capitalize}")
    gd=i.goal_definition
    gd.district = @user.district
    gd.save!
  end
    i.update_attribute(:custom, custom.downcase.strip == 'custom')
    i.update_attribute(:disabled, enabled.downcase.strip == 'disabled')
end


