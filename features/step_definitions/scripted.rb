When /^I log in with basic auth as "([^"]*)" with password "([^"]*)"$/ do |name, password|
  if page.driver.respond_to?(:basic_auth)
    page.driver.basic_auth(name, password)
  elsif page.driver.respond_to?(:basic_authorize)
    page.driver.basic_authorize(name, password)
  elsif page.driver.respond_to?(:browser) && page.driver.browser.respond_to?(:basic_authorize)
    page.driver.browser.basic_authorize(name, password)
  else
    raise "I don't know how to log in!"
  end
end

When /^I enter url "([^"]*)" with abbrev$/ do |url|
  visit "#{url}?district_abbrev=#{@user.district.abbrev}"
end

Given /^a user "([^"]*)"$/ do |username|
  @user = User.find_by_username(username) || Factory(:user,username: username,email: "#{username}@example.com",password: 'e')
end

Given /^a student with district_student_id "([^"]*)"$/ do |id|
  stu=Factory(:student,district_id: @user.district_id).update_attribute(:district_student_id,id)
end

Given /^a probe_definition with id "([^"]*)"$/ do |id|
  InterventionProbeAssignment.delete_all
  RecommendedMonitor.delete_all
  ProbeDefinition.delete_all
  Probe.delete_all
  pd = Factory(:probe_definition, title: 'cuke1', description: 'cuke1', district_id: @user.district_id, 
                                  minimum_score: -10, maximum_score: 10 )
  ProbeDefinition.update_all("id=#{id}", "id = #{pd.id}")
end

Given /^an intervention_definition with id "([^"]*)"$/ do |id|
  InterventionComment.delete_all
  InterventionDefinition.delete_all
  int_def = Factory(:intervention_definition, title: 'cuke1', description: 'cuke1' )
  InterventionDefinition.update_all("id = #{id}", "id = #{int_def.id}")
  GoalDefinition.update_all("district_id = #{@user.district_id}")
end
