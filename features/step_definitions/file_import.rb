Given /^a district "([^\"]*)"$/ do |district_name|
   @district = Factory(:district,:name => district_name)
end

When /^I import_extended_profiles_from_csv with "([^\"]*)", "([^\"]*)"$/ do |filename, district_name|
  @district = District.find_by_name(district_name)
  i = ImportCSV.new(filename, @district)
  i.import
  @command_return_val = i.messages.join(", ")
end

Then /^"([^\"]*)" should have "([^\"]*)" extended profiles$/ do |district_name, num|
  @district ||= District.find_by_name(district_name)
  puts @district.students.collect(&:extended_profile?).inspect
  num_extended_profiles_in_district = @district.students.inject(0) do |num_extended_profiles, student|
    if student.extended_profile?
      num_extended_profiles + 1
    else
      num_extended_profiles
    end
  end
  num_extended_profiles_in_district.should == num.to_i
end

Then /^there should be an extended_profile for student "([^\"]*)"$/ do |student_name|
  first,last = student_name.split(' ')
  Student.find_by_first_name_and_last_name(first,last).extended_profile?.should be_true
end


When /^I import_users_from_csv with "([^\"]*)", "([^\"]*)"$/ do |filename, district_name|
  @district = District.find_by_name(district_name)
  i=ImportCSV.new(filename, @district)
  i.import
  @command_return_val = i.messages.join(", ")
end

Given /^"([^\"]*)" should have "([^\"]*)" users*$/ do |district_name, num_users|
   District.find_by_name(district_name).users.count.should == num_users.to_i
end

Then /^the command should have failed$/ do
  @command_return_val.should_not match(/Successful import/)
end

Then /^the command should have succeeded$/ do
  @command_return_val.should match(/Successful import/)
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

Then /^there should be (\d+) users in the district$/ do |num_users|
    @district ||= @default_user.district
    @district.users.count.should == num_users.to_i
end


Given /^a student "([^\"]*)"$/ do |fullname|
  first,last = fullname.split(' ')
  @student = Factory(:student,:district => @district, :id_district => 31337, :id_state => 33, :first_name => first, :last_name => last)
end

Given /^a school "([^\"]*)"$/ do |arg1|
  @school = Factory(:school,:district=> @district, :id_district => 42)
end

Given /^enrollment "([^\"]*)" in "([^\"]*)" for grade "([^\"]*)"$/ do |arg1, arg2, grade|
  @student.enrollments.create(:school=>@school, :grade=>grade, :end_year => 2009)
end

When /^I import_enrollments_from_csv with "([^\"]*)", "([^\"]*)"$/ do |filename, district|
  i=ImportCSV.new(filename, @district)
  i.import
  @command_return_val = i.messages.join(", ")
end

Then /^"([^\"]*)" should have "([^\"]*)" enrollments$/ do |arg1, enrollment_count|
  @school.enrollments.count.should ==  enrollment_count.to_i
end

Then /^"([^\"]*)" has \[(.*)\] for grades$/ do |arg1, grades|
  @school.enrollments.collect(&:grade).sort.join(", ").should == grades
end

When /^I import_csv with "([^\"]*)"$/ do |filename|
  i=ImportCSV.new(filename, @district)
  i.import
  @command_return_val = i.messages.join(", ")
end

 
Then /^there should be "([^\"]*)" students*$/ do |count|
  @district.students(reload=true).count.should == count.to_i 
end
  
Then /^the system should have "([^\"]*)" students not assigned to districts$/ do |count|
  Student.scoped_by_district_id(nil).count.should == count.to_i

end
  

Given /^no other users$/ do
   User.delete_all
end

Given /^no other students$/ do
   Student.delete_all
end
