Given /^require everything$/ do
  #only called once
  MyCoveralls.require_all_ruby_files ["app", "lib"]
end
