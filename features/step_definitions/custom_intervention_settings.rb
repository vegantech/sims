When /^I reload based on the following table:$/ do |table|
  table.hashes.each do |row|
    # setting content_admin? display?
    cucumber_district.update_attribute :custom_interventions, row["setting"]
    if row["content_admin?"] == "true"
      cucumber_user.roles = ["regular_user","content_admin"]
    else
      cucumber_user.roles = ["regular_user"]
    end
    cucumber_user.save
    visit current_path
    text= "Create New Custom Intervention and Progress Monitor"
    if row["display?"] == "true"
      page.should have_content(text), row.inspect
    else
      page.should have_no_content(text), row.inspect
    end
  end
end

Then /^the custom intervention should have the school and user set$/ do
  ci= InterventionDefinition.last
  ci.user_id.should == @default_user.id
  ci.school_id.should == @school.id
end

Given /^a single intervention category$/ do
  gd=Factory(:goal_definition, district: cucumber_district)
  od=Factory(:objective_definition, goal_definition: gd)
  @category = Factory(:intervention_cluster, objective_definition: od)
end

Given /^an assortment of custom interventions$/ do
  Factory(:intervention_definition, intervention_cluster: @category, title: "same_user_same_school",
                                    user_id: cucumber_user.id, school_id: cucumber_school.id, custom: true)
  Factory(:intervention_definition, intervention_cluster: @category, title: "same_user_different_school",
                                    user_id: cucumber_user.id, school_id: -1, custom: true)
  Factory(:intervention_definition, intervention_cluster: @category, title: "different_user_same_school",
                                    user_id: -1, school_id: cucumber_school.id, custom: true)
  Factory(:intervention_definition, intervention_cluster: @category, title: "different_user_different_school",
                                    user_id: -1, school_id: -1, custom: true)
end

Then /^I start a new intervention based on the following table:$/ do |table|
  table.hashes.group_by{|r| r["setting"]}.each do |setting, rows|
    cucumber_district.update_attribute :custom_interventions, setting
    visit new_intervention_url
    rows.each do |row|
      if row["display?"] == "true"
        page.should have_content(row["intervention"]), row.inspect
      else
        page.should have_no_content(row["intervention"]), row.inspect
      end
    end
  end
end

Given /^I select <<(\d+) years? ago>> from "(.*?)"$/ do |year,field|
  step "select \"#{Date.today.year - year.to_i}\" from \"#{field}\""
end

