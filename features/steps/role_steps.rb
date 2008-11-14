Given /there are (\d+) roles/ do |n|
  Role.transaction do
    Role.destroy_all
    n.to_i.times do |n|
      Role.create! :name => "Role #{n}"
    end
  end
end

When /I delete the first role/ do
  visits roles_url
  clicks_link "Destroy"
end

Then /there should be (\d+) roles left/ do |n|
  Role.count.should == n.to_i
  response.should have_tag("table tr", n.to_i + 1) # There is a header row too
end
