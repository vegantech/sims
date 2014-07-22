Given /^student exists with id_state of (.*)$/ do |id_state|
  Factory(:student, :district => @user.district, :id_state => id_state.to_i)
end

Then /^I call ajax check_id_state with "(.*)"$/ do |id_state|
  visit check_id_state_district_students_url(:student=>{:id_state=>id_state}, :format => 'js')
end

Then /^I should see an alert$/ do
  page.source.should =~ /alert/
end

Then /^I should not see an alert$/ do
  page.source.should_not =~ /alert/
end

Given /^student exists with no district and id_state of (.*)$/ do |id_state|
  s=Factory(:student, :district_id => 1, :id_state => id_state.to_i)
  s.update_attribute(:district_id, nil)
end

Then /^page should not contain "([^\"]*)"$/ do |taboo|
    page.source.should_not =~ /#{taboo}/
end

Then /^page source should contain \/(.*)\/$/ do |taboo|
    page.source.should =~ /#{taboo}/
end

Then /^page source should contain "([^\"]*)"$/ do |taboo|
    page.source.should =~ /#{taboo}/
end

When /^I follow Claim First Last for your district$/ do
  page.driver.put claim_district_student_url(Student.last)
end

When /^I magically visit "([^\"]*)"$/ do |_url|
  #'  Element.update("claim_student", "<a href=\"/district/students/claim/996332878?method=put\">Claim First Last for your district</a>"); '
  page.source.match  /\"\/(dis.*)\?/
  xhr  "put", "#{$1}", :user_id => @user.id.to_s, :district_id => @user.district_id.to_s
  step 'I follow "redirected"' if page.has_content? 'redirected'
end


Given /^a school in my district named "([^\"]*)"$/ do |name|
  @default_user.district.schools.find_by_name(name) or Factory(:school,:name => name, :district_id => @default_user.district_id)
end

Given /^I am assigned to "([^"]*)"$/ do |_name|
    s=Factory(:school, :district_id => @user.district_id)
    @user.staff_assignments.create!(:school=> s)
end

Given /^the other district admin is gone$/ do
  User.delete_all("username = 'district_admin'")
end

Given /^the district has (\d+) users$/ do |num_users|
  ActiveRecord::Base.transaction do
    num_users.to_i.times do
      ActiveRecord::Base.connection.insert_sql "insert into users (district_id) values(#{@user.district_id}) " 
    end
  end
end

