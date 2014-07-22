Given /^TestOnSimsOpen$/ do
  visit "http://training20.sims-open.vegantech.com"
  fill_in "Login", with: "oneschool"
  fill_in "Password", with: "oneschool"
  click_button 'Login'
  click_button 'Search for Students'
  check 'select_all'
  sleep 0.5
  page.all('tbody [type="checkbox"]').each {|c| c['checked'].should be_true}
  
  check 'select_all'
  sleep 0.5
  page.all('tbody [type="checkbox"]').each {|c| c['checked'].should be_false}

end

Given /^Go to the training20^/ do
  visit "http://training20.sims-open.vegantech.com"
end

When /^Check what's new^/ do
  # what's new should not be visible
  # click what's new
  # #what's new should be visible
  #
end

When /^Check Help Popup^/ do
  # mouse over help ?
  # confirm text
  # mouseoff help?
end


