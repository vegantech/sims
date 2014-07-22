Given /^there are no tiers$/ do
  Tier.delete_all
end

Given /^I am the principal$/ do
  @default_user.user_group_assignments.update_all(is_principal: true)
  @default_user.update_attribute(:email, "sims_cucumber_principal@example.com")
  @default_user.update_attribute(:district_id, @district.id)
  Student.update_all(district_id: @district.id)
end

Given /^there is a principal override request$/ do

  stu= @default_user.user_group_assignments.first.group.students.first
  po=@default_user.principal_override_requests.build(student: stu, teacher_request: 'Cucumber test reaquest', skip_email: true)
  po.save!
end

Given /^Principal Override Reason "([^\"]*)" "([^\"]*)"$/ do |reason, autopromote|
  autopromote = (autopromote == "autopromote")
  @district.principal_override_reasons.create!(reason: reason, autopromote: autopromote)
end

Given /^tiers \["([^\"]*)", "([^\"]*)", "([^\"]*)"\]$/ do |arg1, arg2, arg3|
  @district.tiers.delete_all
    @district.tiers.create!(title: arg1)
    @district.tiers.create!(title: arg2)
    @district.tiers.create!(title: arg3)
end
