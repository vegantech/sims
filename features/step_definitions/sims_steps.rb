Given /^common data$/i do
  @default_user = default_user
  clear_login_dropdowns
  @district = default_district
  @default_user.district = @district
  @school = Factory(:school, :district => @district, :name => "Default School")
  @default_user.schools << @school
  @another_user = Factory(:user, :username => "cucumber_another", :district => @district)
  @another_user.schools << @school
  @default_user.save!
  create_default_student
  @student.district = @district
  @student.save!
  create_default_intervention_pieces
end

Given /^user "([^\"]*)" with no password in district with key "([^\"]*)"$/ do |user_name, key|
  clear_login_dropdowns
  create_user user_name, 't'

  @user.update_attribute(:passwordhash,'')
  @user.update_attribute(:salt,'')
  @user.update_attribute(:email,'b723176@madison.k12.wi.us')
  @user.district.update_attribute(:key, key)


end

Given /clear login dropdowns/ do
  clear_login_dropdowns
end



Given /^with additional student$/i do
  s=Factory(:student,:district=>@student.district)
  s.enrollments.create!(@student.enrollments.first.attributes)
  @additional_student=true
  s.save!
end

Given /^quicklist choices (.*)$/i do |choices_array|
  choices = Array(eval(choices_array))
  goal = Factory(:goal_definition, :title => "Cucumber Goal", :district => @district)
  objective = Factory(:objective_definition, :title=> "Cucumber Objective", :goal_definition => goal)
  cluster = Factory(:intervention_cluster, :title => "Cucumber Category", :objective_definition => objective)
  
  choices.each do |choice|
    idef = Factory(:intervention_definition, :title => choice, :intervention_cluster => cluster)
    Factory(:quicklist_item, :school => @school, :intervention_definition => idef)
  end
end

Given /^user "(.*)" with password "(.*)" exists$/ do |user_name, password|
  clear_login_dropdowns
  create_user user_name, password
end

Given /^I log in as content_builder$/ do
  District.destroy_all
  InterventionDefinition.destroy_all
  GoalDefinition.destroy_all
  ObjectiveDefinition.destroy_all
  InterventionCluster.destroy_all
  Factory(:tier)
  Factory(:time_length)
  Factory(:frequency)
  clear_login_dropdowns
  u=create_user "content_builder", "content_builder"
  u.roles = "content_admin"
  u.save!
  @content_district = u.district

  visit '/'
  fill_in 'Login', :with => 'content_builder'
  fill_in 'Password', :with => 'content_builder'
  click_button 'Login'
end

Given /^I am a district admin$/ do
  clear_login_dropdowns
  log_in
  @default_user.roles = (Role.mask_to_roles(@default_user.roles_mask) | ["local_system_administrator"])
  @default_user.save!
end

Given /^I am a school admin$/ do
  clear_login_dropdowns
  log_in
  @default_user.roles = (Role.mask_to_roles(@default_user.roles_mask) | ["school_admin"])
  @default_user.user_school_assignments.create(:school_id => @school.id, :admin=>true)
  @default_user.save!
end

Given /^there is a student in my group$/ do
  s=create_student "A", "Student", "05", @school
  g=@school.groups.create!(:title => "My Group")
  g.students << s
  g.users << @default_user
end




Given /^I am a state admin$/ do
  Given "I am a district admin"
  @default_user.roles = (Role.mask_to_roles(@default_user.reload.roles_mask) | ['state_admin'])
  @default_user.save!
  @default_user.district.update_attribute(:admin , true)
end

Given /^I enter default student url$/ do
  visit "/students/#{@student.id}"
end

Given /^I enter url "(.*)"$/ do |url|
  visit url
end

When /^I start at (.*)$/ do |page_name|
  go_to_page page_name
end

Given /^"(.*)" has access to (.*)$/ do |user_name, group_array|
  grant_access user_name, group_array
end

# TODO: combine with above method...
Given /^I have access to (.*)$/ do |group_array|
  grant_access 'default_user', group_array
end

Given /^student "([^"]*)" "([^"]*)" in grade (\d+) at "([^"]*)" with "([^"]*)" flag and ignore_flag for "([^"]*)" with reason "([^"]*)"$/ do |first, last, student_grade, school_name, flag_type, ignored_type, reason|
	school = School.find_by_name(school_name)
	create_student first, last, student_grade, school, flag_type, ignored_type, reason
end

Given /^student "(.*)" "(.*)" in grade (\d+) at "(.*)" with "(.*)" flag$/ do |first, last, student_grade, school_name, flag_type|
	school = School.find_by_name(school_name)
	create_student first, last, student_grade, school, flag_type
end

Given /^student "([^"]*)" "([^"]*)" in grade (\d+) at "([^"]*)"$/ do |first, last, student_grade, school_name|
	school = School.find_by_name(school_name)
	create_student first, last, student_grade, school
end

Given /^student "([^"]*)" "([^"]*)" in grade (\d+) at "([^"]*)" in (\d+)$/ do |first, last, student_grade, school_name, year|
	school = School.find_by_name(school_name)
	s= create_student first, last, student_grade, school
  s.enrollments.first.update_attribute(:end_year,year)
end




Given /^student "([^"]*)" "([^"]*)" in grade (\d+) at "([^"]*)" with ignore_flag for "(.*)" with reason "(.*)"$/ do
  |first, last, student_grade, school_name, ignore_type, reason|
	school = School.find_by_name(school_name)
	s=create_student first, last, student_grade, school
  s.ignore_flags.create!(:category=>ignore_type, :reason=>reason)
end

Given /^student "([^"]*)" "([^"]*)" in grade (\d+) at "([^"]*)" with custom_flag for "(.*)" with reason "(.*)"$/ do
  |first, last, student_grade, school_name, custom_type, reason|
	school = School.find_by_name(school_name)
	s=create_student first, last, student_grade, school
  s.custom_flags.create!(:category=>custom_type, :reason=>reason)
end

# # use this if you want the default user to belong to a group for the school
# Given /^accessible school "(.*)"$/ do |school_name|
#   s = create_school school_name
#   group = Group.create!(:title => "Default Group for #{school_name}", :school => s)
#   UserGroupAssignment.create!(:user => default_user, :group => group)
# end

Given /^school "(.*)"$/ do |school_name|
	create_school school_name
end

Then /^I should see select box with id of "(.*)" and contains (.*)$/ do |id, options|
  verify_select_box id, options
end

Given /group "(.*)" for school "([^\"]*)"$/ do |group_title, school_name|
  school = School.find_by_name(school_name)
  group = Group.find_or_create_by_title_and_school_id(group_title, school.id)
end

Given /group "(.*)" for school "(.*)" with student "([^\"]*)"$/ do |group_title, school_name, student_name|
  school = School.find_by_name(school_name)
  group = Group.create!(:title => group_title, :school => school)
  first,last=student_name.split(" ")
  student = create_student(first,last, '1', school)
  group.students << student
end

# TODO: extract helper
Given /group "(.*)" for school "(.*)" with student "([^\"]*)" in grade "(.*)"$/ do |group_title, school_name, student_name, grade|
  school = School.find_by_name(school_name)
  group = Group.create!(:title => group_title, :school => school)
  first,last=student_name.split(" ")
  student = create_student(first,last, grade, school)
  group.students << student
end

Given /group "(.*)" for school "(.*)" with students (.*)$/ do |group_title, school_name, students_array|
  school = School.find_by_name(school_name)
  group = Group.create!(:title => group_title, :school => school)

  students = Array(eval(students_array))
  students.each do |student_name|
    first, last = student_name.split(" ")
    student = find_student(first, last) || create_student(first,last, '1', school)
    group.students << student
  end
end


Given /^load demo data$/ do
  fixtures_dir = File.expand_path(RAILS_ROOT)+ '/test/fixtures'

  Fixtures.reset_cache
  Dir.entries(fixtures_dir).select{|e| e.include?"yml"}.each do |f|
    Fixtures.create_fixtures(fixtures_dir, File.basename("#{f}", '.*'))
  end
end

Then /^I Display Body$/i do
  puts response.body
end

When /^I should click js "all"$/ do 
  click_all_name_id_brackets
end

# Given /^I should see javascript code that will do xhr for "search_criteria_grade" that updates ["search_criteria_user_id", "search_criteria_group_id"]$/ do
Given /^I should see javascript code that will do xhr for "(.*)" that updates (.*)$/ do |observed_field, target_fields|
  response.body.should match(/Form.Element.EventObserver\('#{observed_field}'/)
end

# When /^xhr "search_criteria_user_id" updates ["search_criteria_group_id"]
When /^xhr "(.*)" updates (.*)$/ do |observed_field, target_fields|
  user=User.find_by_username("default_user")
  other_guy=User.find_by_username("Other_Guy")
  school=School.find_by_name("Central")

  if observed_field == "search_criteria_grade"
    xml_http_request  :post, "/students/grade_search/", {:grade=>3}, {:user_id => user.id.to_s, :school_id=>school.id.to_s}
  elsif observed_field == "search_criteria_user_id"
    xml_http_request  :post, "/students/member_search/", {:grade=>3,:user=>other_guy.id.to_s}, {:user_id => user.id.to_s, :school_id=>school.id.to_s}
  else
    flunk response.body
  end

  Array(eval(target_fields)).each do |target_field|
    response.body.should match(/Element.update\("#{target_field}"/)
  end
  #  response.should hav_text /"<option value=\"996332878\">default user</option>");"/
end

Then /^I should verify rjs has options (.*)$/ do |options|
  response.should have_options(Array(eval(options)))
end

Given /^I enter URL "(.*)"$/ do |url|
  visit url
end

Given /^there are "(\d+)" emails$/ do |num_emails|
  assert_emails num_emails.to_i
end

Given /^there is not an email containing "(.*)"$/ do |target_text|
  assert_no_emails
end

Given /^there is an email containing "(.*)"$/ do |target_text|
  #  assert_emails 2
  # ActionMailer::Base.perform_deliveries = true
  last_mail = ActionMailer::Base.deliveries.join("********")
  last_mail.should match(/#{target_text}/)
end

When /^I press within (.*)$/ do | scope|
  within(scope) do |scoped|
    scoped.click_button
  end
end

Given /^other district team note "(.*)" on "(.*)"$/ do |content, date_string|
  date = date_string.to_date
  nondistrict_student = Factory(:student)  #will create another district
  StudentComment.create!(:student => nondistrict_student, :body => content, :created_at => date)
end

Given /^team note "(.*)" on "(.*)"$/ do |content, date_string|
  date = date_string.to_date
  StudentComment.create!(:student => @student, :body => content, :created_at => date)
end

Given /^other school team note "(.*)" on "(.*)"$/ do |content, date_string|
  date = date_string.to_date
  non_selected_school_student = Factory(:student, :district => @student.district) #will create student in an unselected school
  StudentComment.create!(:student => non_selected_school_student, :body => content, :created_at => date)
end

Given /^unauthorized student team note "(.*)" on "(.*)"$/ do |content, date_string|
  date = date_string.to_date
  unauthorized_student = Factory(:student, :district => @student.district)  #will create a student in same district
  unauthorized_student.enrollments.create!(:grade => "ZZ", :school => @student.enrollments.first.school)

  # TODO: Change this, so it doesn't remain a trap for later?
  @default_user.special_user_groups.destroy_all
  @default_user.special_user_groups.create!(:grouptype=>SpecialUserGroup::ALL_STUDENTS_IN_SCHOOL,:school_id=>@school.id, :grade=>@student.enrollments.first.grade,
                                           :district => @default_user.district)

  StudentComment.create!(:student => unauthorized_student, :body => content, :created_at => date)
end

When /^page should contain "(.*)"$/ do |arg1|
  response.body.should =~ /#{arg1}/
end

Given /^student "([^\"]*)" directly owns consultation form with team consultation concern "([^\"]*)"$/ do |student_name, concern_label|
  first_name, last_name = student_name.split
  student = Student.find_by_first_name_and_last_name(first_name, last_name)
  tc=nil
  consultation_form = Factory(:consultation_form, :team_consultation => tc)

  concern = Factory(:consultation_form_concern,  :strengths => "Strengths #{concern_label}", :concerns => "Concerns #{concern_label}",
    :recent_changes => "Recent changes #{concern_label}", :area => 3)

  consultation_form.consultation_form_concerns << concern
  team_consultation = Factory(:team_consultation, :consultation_form => consultation_form)
  student.team_consultations << team_consultation
end

Given /^student "([^\"]*)" directly owns consultation form with concern "([^\"]*)"$/ do |student_name, concern_label|
  first_name, last_name = student_name.split
  student = Student.find_by_first_name_and_last_name(first_name, last_name)
  tc=TeamConsultation.create!(:student=>student)
  consultation_form = Factory(:consultation_form, :team_consultation => tc)

  concern = Factory(:consultation_form_concern,  :strengths => "Strengths #{concern_label}", :concerns => "Concerns #{concern_label}",
    :recent_changes => "Recent changes #{concern_label}", :area => 3)

  consultation_form.consultation_form_concerns << concern
end

Then /^"([^\"]*)" should have "([^\"]*)" groups$/ do |school_name, num_groups|
  school = School.find_by_name(school_name)
  school.groups.size.should == num_groups.to_i
end


Given /^district "([^"]*)"$/ do |district|
  Factory(:district, :name => district)
end

Then /^"([^"]*)" should have "([^"]*)" district selected$/ do |field, district|
    i=District.find_by_name(district).id
    steps %Q{Then the "#{field}" field should contain "#{i}"}
end
