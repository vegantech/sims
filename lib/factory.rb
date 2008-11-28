require 'factory-girl'

Factory.sequence :username do |n|
  "user#{n}"
end

Factory.define :checklist do |c|
  c.association, :student
  c.association, :user
  c.association, :tier
end

Factory.define :user do |u|
  u.username {Factory.next}
  u.passwordhash "password"
  u.last_name "Last_Name"
  u.first_name {"First#{u.username}"}
end
  

