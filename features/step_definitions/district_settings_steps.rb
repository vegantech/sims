Then /^all boolean district settings should be false$/ do
  @default_user.district.reload
  District::BOOLEAN_SETTINGS.each do |setting|
    @default_user.district.send("#{setting}?").should be_false, setting.to_s + "? should be false"
  end
end

When /^I check all district_settings boxes$/ do
  District::BOOLEAN_SETTINGS.each do |setting|
    check("district_#{setting}")
  end
end

When /^I uncheck all district_settings boxes$/ do
  District::BOOLEAN_SETTINGS.each do |setting|
    uncheck("district_#{setting}")
  end
end




Then /^all boolean district settings should be true$/ do
  @default_user.district.reload
  District::BOOLEAN_SETTINGS.each do |setting|
    @default_user.district.send("#{setting}?").should be, setting.to_s + "? should be truthy"
  end
end
