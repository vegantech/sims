Given /^a district "([^\"]*)"$/ do |district_name|
   @district = Factory(:district,:name => district_name)
end

When /^I import_users_from_csv with "([^\"]*)", "([^\"]*)"$/ do |filename, district_name|
  @district = District.find_by_name(district_name)
  @command_return_val = ImportCSV::load_users_from_csv(filename,@district)
end

Given /^"([^\"]*)" should have "([^\"]*)" users*$/ do |district_name, num_users|
   District.find_by_name(district_name).users.count.should == num_users.to_i
end

Then /^the command should have failed$/ do
  @command_return_val.should_not be_true
end

Then /^the command should have succeeded$/ do
  @command_return_val.should be_true
end

Then /^there should be a user with username "([^\"]*)"$/ do |username|
  @district.users.find_by_username(username).should be_true
end

Given /^user "([^\"]*)" in district "([^\"]*)" with password "([^\"]*)"$/ do |username, district_name, password|
  district = District.find_by_name(district_name)
  Factory(:user, :district=>district, :password => password, :username => username, :id_district => rand(50000))
end

Given /^User "([^\"]*)" should authenticate with password "([^\"]*)" for district "([^\"]*)"$/ do |username, password, district_name|
   District.find_by_name(district_name).users.authenticate(username, password).should be_true
end
