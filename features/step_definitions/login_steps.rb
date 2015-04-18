When /^I pick my district$/ do
    select(@user.district.name, :from => "District")
end

Given /^user has expired token$/ do
  @reset_token = @user.send_reset_password_instructions
  @user.update_attribute(:reset_password_sent_at, 2.years.ago)
end

When /^I am at the recovery_url$/ do
  visit "/users/password/edit?district_abbrev=#{@user.district.abbrev}&reset_password_token=#{@reset_token}"
end
