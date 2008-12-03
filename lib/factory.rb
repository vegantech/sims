require 'factory_girl'

Factory.sequence :username do |n|
  "user#{n}#{Time.now.to_i}"
end

Factory.define :checklist do |c|
  c.association :student
  c.association :user
  c.association :tier
  c.association :checklist_definition
end

Factory.define :user do |u|
  u.username {Factory.next(:username)}
  u.passwordhash {|u| User.encrypted_password(u.username)}
  u.last_name "Last_Name"
  u.first_name {|u| "First#{u.username}"}
end

Factory.define :checklist_definition do |c|
  c.directions "Please folow the directions"
  c.text "Text for Checklist"
  c.association :question_definitions, :factory=>:question_definition
end

Factory.define :tier do |t|
  t.title "Some tier"
end

Factory.define :student do |s|
  s.last_name "Last"
  s.first_name "First"
end

Factory.define :question_definition do |q|
  q.text  "Question"
  q.association :element_definitions, :factory =>:element_definition
end

Factory.define :element_definition do |e|
  e.text  "Element"
  e.kind  'relevant'
  e.association :answer_definitions, :factory => :answer_definition
end

Factory.define :answer_definition do |a|
  a.value 0
end

Factory.define :district do |d|
  d.abbrev "test"
  d.name "Test District"
end

Factory.define :school do |s|
  s.name "Test School"
  s.association :district
end








  

