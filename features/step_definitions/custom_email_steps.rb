#Commonly used email steps
#
# To add your own steps make a custom_email_steps.rb
# The provided methods are:
#
# reset_mailer
# open_last_email
# visit_in_email
# unread_emails_for
# mailbox_for
# current_email
# open_email
# read_emails_for
# find_email

Then %r{^I should see "([^"]*?)" in the email$} do |text|
  current_email.body.should =~ Regexp.new(text)
end

When /^I click the change_password link in the email$/ do
  current_email.body.should =~ /#{@user.district.abbrev}.example.com/
  current_email.body.should =~ /change_password\?id=#{@user.id}&token=#{@user.reload.token}/
  visit("/change_password?id=#{@user.id}&token=#{@user.token}&district_abbrev=#{@user.district.abbrev}")
end


