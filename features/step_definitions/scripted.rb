Given /^a user "([^"]*)"$/ do |username|
  @user = User.find_by_username(username) || Factory(:user,:username=>username,:email => "#{username}@example.com",:password=>'e')
end

When /^I upload the automated_intervention sample file using curl$/ do
  system 'script/server -p39001 -e cucumber &'
  sleep 10 #allow test server to run
  `curl --user automated_intervention:e  -Fupload_file=@./test/csv/automated_intervention/sample.csv http://127.0.0.1:39001/scripted/automated_intervention?district_abbrev=#{@user.district.abbrev}`
  system "kill `ps aux | grep script/server | grep -e '-p 39001' | grep -v grep | awk '{ print $2 }'`"

end

