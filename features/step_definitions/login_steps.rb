When /^I pick my district$/ do
    select(@user.district.name, from: "District")
end

Given /^user has expired token$/ do
  @user.send :generate_reset_password_token!
  @user.update_attribute(:reset_password_sent_at, 2.years.ago)
end

When /^I am at the recovery_url$/ do
  visit "/users/password/edit?district_abbrev=#{@user.district.abbrev}&reset_password_token=#{@user.reset_password_token}"
end

When /^I am at the old recovery_url$/ do
  visit "/change_password?district_abbrev=#{@user.district.abbrev}&token=#{@user.reset_password_token}"
end
