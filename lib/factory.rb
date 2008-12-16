require 'factory_girl'

Factory.sequence :username do |n|
  "user#{n}#{Time.now.to_i}"
end

Factory.sequence :abbrev do |a|
  "test#{a}"
end

Factory.define :checklist do |c|
  c.association :student
  c.association :user
  c.association :tier
  c.association :checklist_definition
end

Factory.define :country do |c|
  c.abbrev {Factory.next(:abbrev)}
  c.name {|c| "#{c} Country"}
end

Factory.define :user do |u|
  u.username {Factory.next(:username)}
  u.password {|u| u.username}
  u.password_confirmation {|u| u.password}
  u.last_name "Last_Name"
  u.first_name {|u| "First#{u.username}"}
  u.association :district
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
  d.abbrev {Factory.next(:abbrev)}
  d.name {|c| "#{c.abbrev} District"}
  d.association :state
end

Factory.define :school do |s|
  s.name "Test School"
  s.association :district
end


Factory.define :state do |s|
  s.abbrev {Factory.next(:abbrev)}
  s.name {|c| "#{c} State"}
  s.association :country
end
