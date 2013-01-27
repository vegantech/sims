When /^I select a blank year$/ do
  b=find(:css, 'option[value=""]').select_option
end

Then /^page should have a "([^"]*)" button$/ do |button_name|
    page.should have_button button_name
end


