Given /^Shawn Balestracci is a team scheduler$/ do
  u = Factory(:user, :first_name => 'Shawn', :last_name => 'Balestracci', :email => 'b723176@madison.k12.wi.us')
  @school.team_schedulers.create!(:user => u)
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

