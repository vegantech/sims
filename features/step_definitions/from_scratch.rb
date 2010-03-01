Given /^System Bootstrap$/ do
  School.destroy_all
  District.destroy_all
  State.destroy_all
  Country.destroy_all
  System.bootstrap
end

