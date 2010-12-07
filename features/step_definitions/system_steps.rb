Given /^require everything$/ do
  #only called once
  Coveralls.require_all_ruby_files ["/app"]
end

Given /^I clear the headers in rack_test$/ do
  set_headers({"HTTP_X_HTTP_METHOD_OVERRIDE"=>nil})
  set_headers({"REQUEST_METHOD"=>nil})
end

