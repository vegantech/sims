Given /^Shawn Balestracci is a team contact for "([^\"]*)"$/ do |team_name|
  u = Factory(:user, :first_name => 'Shawn', :last_name => 'Balestracci', :email => 'b723176@madison.k12.wi.us')
  @user ||= u
  st=@school.school_teams.find_or_create_by_name(team_name)
  st.contact_ids = [u.id]
  st.save!
end

When /^I follow "([^\"]*)" "([^\"]*)"$/ do |arg1, arg2|
  if arg2 == 'TODAY'
    date = Date.today
    arg1.sub!(/_CHANGE_TO_VARIABLE_/, "#{date}")
    When "I follow \"#{arg1}\""
  else
    fail
  end
end

When /^The district is set to email on responses$/ do
  @user.district.update_attribute :email_on_team_consultation_response, true
end

When /^The district is not set to email on responses$/ do
  @user.district.update_attribute :email_on_team_consultation_response, false
end
