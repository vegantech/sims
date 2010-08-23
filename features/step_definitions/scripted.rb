When /^I log in with basic auth as "([^"]*)" with password "([^"]*)"$/ do |username, password|
  basic_auth(username, password)
end

When /^I enter url "([^"]*)" with abbrev$/ do |url|
  visit "#{url}?district_abbrev=#{@user.district.abbrev}"
end



Given /^a user "([^"]*)"$/ do |username|
  @user = User.find_by_username(username) || Factory(:user,:username=>username,:email => "#{username}@example.com",:password=>'e')
end

Given /^a student with district_student_id "([^"]*)"$/ do |id|
  stu=Factory(:student,:district_id => @user.district_id).update_attribute(:district_student_id,id)
end

Given /^an intervention_definition with id "([^"]*)"$/ do |id|
  int_def = Factory(:intervention_definition, :title => 'cuke1', :description => 'cuke1' )
  InterventionDefinition.update_all("id = #{id}", "id = #{int_def.id}")
  GoalDefinition.update_all("district_id = #{@user.district_id}")
end



When /^I upload the automated_intervention sample file using curl$/ do
  system 'script/server -p39001 -e cucumber &'
  sleep 10 #allow test server to run
  `curl --user automated_intervention:e  -Fupload_file=@./test/csv/automated_intervention/sample.csv http://127.0.0.1:39001/scripted/automated_intervention?district_abbrev=#{@user.district.abbrev}`
  system "kill `ps aux | grep script/server | grep -e '-p 39001' | grep -v grep | awk '{ print $2 }'`"

end

