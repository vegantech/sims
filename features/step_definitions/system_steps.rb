Given /^require everything$/ do
  #only called once
  Coveralls.require_all_ruby_files ["/app", "/lib"]
end
