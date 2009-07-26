Given /^there are no tiers$/ do
    Tier.delete_all
end

Given /^I am the principal$/ do
  @default_user.user_group_assignments.update_all(:is_principal => true)
  @default_user.update_attribute(:email, "sims_cucumber_principal@example.com")
end

Given /^there is a principal override request$/ do

  stu= @default_user.user_group_assignments.first.group.students.first
  po=@default_user.principal_override_requests.build(:student=>stu, :teacher_request => 'Cucumber test reaquest')
  po.stub!(:notify)
  po.save!
  #  pending
end
    
