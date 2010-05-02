Given /^System Bootstrap$/ do
  School.destroy_all
  District.destroy_all
  System.bootstrap
end

