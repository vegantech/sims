When /^I select a blank year$/ do
  b=locate(:css, 'option[value=""]')
  b.node['selected']='selected'
end

Then /^page should have a "([^"]*)" button$/ do |button_name|
    page.should have_button button_name
end


