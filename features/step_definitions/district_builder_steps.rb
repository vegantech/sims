Then /^pending testing enrollment flags and extended profile$/ do
  pending
end

Given /^student exists with id_state of (.*)$/ do |id_state|
  Factory(:student, :district => @user.district, :id_state => id_state.to_i)
end

Then /^I call ajax check_id_state with "(.*)"$/ do |id_state|
  set_headers({"HTTP_X_REQUESTED_WITH" => "XMLHttpRequest"})
  visit check_id_state_district_students_url(:student=>{:id_state=>id_state})
end
  
Then /^I should see an alert$/ do
  page.body.should =~ /alert/
end

Then /^I should not see an alert$/ do
  page.body.should_not =~ /alert/
end

Given /^student exists with no district and id_state of (.*)$/ do |id_state|
  s=Factory(:student, :district_id => 1, :id_state => id_state.to_i)
  s.update_attribute(:district_id, nil)
end

Then /^page should not contain "([^\"]*)"$/ do |taboo|
    page.body.should_not =~ /#{taboo}/
end
  
When /^I magically visit "([^\"]*)"$/ do |url|
  #'  Element.update("claim_student", "<a href=\"/district/students/claim/996332878?method=put\">Claim First Last for your district</a>"); '
    page.body.match  /\"\/(dis.*)\?/
    set_headers({"HTTP_X_HTTP_METHOD_OVERRIDE"=>"PUT"})
    set_headers({"REQUEST_METHOD"=>"PUT"})

    visit "/#{$1}"
end
  

Given /^a school in my district named "([^\"]*)"$/ do |name|
  @default_user.district.schools.find_by_name(name) or Factory(:school,:name => name, :district_id => @default_user.district_id)
end


