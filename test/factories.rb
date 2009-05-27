Factory.sequence :username do |n|
  "user#{n}#{Time.now.to_i}"
end

Factory.sequence :abbrev do |a|
  "test#{a}#{Time.now.to_i}"
end

Factory.define :checklist do |c|
  c.association :student
  c.association :teacher, :factory => :user
  c.association :tier
  c.association :checklist_definition
end

Factory.define :consultation_form do |cf|
end

Factory.define :consultation_form_concern do |cfc|
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
  c.question_definitions {|question_definitions| [question_definitions.association(:question_definition)]}
end

Factory.define :enrollment do |e|
  e.grade "01"
  e.association :student
  e.association :school
end

Factory.define :group do |g|
  g.title {Factory.next :abbrev}
  g.association :school
  end

Factory.define :tier do |t|
  t.title "Some tier"
end

Factory.define :student do |s|
  s.last_name "Last"
  s.first_name "First"
  s.association :district
end

Factory.define :question_definition do |q|
  q.text  "Question"
  q.element_definitions {|ed| [ed.association(:element_definition, :question_definition_id=>Time.now.to_i)]}
end

Factory.define :element_definition do |e|
  e.text  "Element"
  e.kind  'applicable'
  e.answer_definitions {|ad| [ad.association(:answer_definition)]}
end

Factory.define :answer do |a|
  a.association :answer_definition
  a.text "Answer"
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
  s.name {"#{Factory.next(:abbrev)} School"}
  s.association :district
end

Factory.define :state do |s|
  s.abbrev {Factory.next(:abbrev)}
  s.name {|c| "#{c} State"}
  s.association :country
end

Factory.define :intervention_participant do |ip|
  ip.association :user
  ip.association :intervention
  ip.role InterventionParticipant::PARTICIPANT
end

Factory.define :intervention do |i|
  i.association :user
  i.association :student
  i.frequency_multiplier 1
  i.association :frequency
  i.time_length_number 1
  i.association :time_length
  i.association :intervention_definition
  i.start_date Date::civil(2008, 11, 1)
  i.end_date Date::civil(2008, 12, 1)
end

Factory.define :intervention_definition do |id|
  id.title {Factory.next(:abbrev) + "TITLE"}
  id.description {|i| i.title + "Description"}
  id.association :time_length
  id.association :frequency
  id.time_length_num 1
  id.frequency_multiplier 1
  id.association :intervention_cluster
  id.association :tier
end

Factory.define :intervention_cluster do |ic|
  ic.title {Factory.next(:abbrev) + "TITLE"}
  ic.description {|i| i.title + "Description"}
  ic.association :objective_definition
end

Factory.define :objective_definition do |od|
  od.title {Factory.next(:abbrev) + "TITLE"}
  od.description {|i| i.title + "Description"}
  od.association :goal_definition
end

Factory.define :goal_definition do |gd|
  gd.title {Factory.next(:abbrev) + "TITLE"}
  gd.description {|i| i.title + "Description"}
  gd.association :district
end

Factory.define :quicklist_item do |qi|
  qi.association :intervention_definition
  qi.association :school
  #qi.association :district (it's one or the other)
end

# TODO: validate time length
Factory.define :time_length do |tl|
  tl.days 2
  tl.title "Default"
end

Factory.define :frequency do |f|
  f.title 'Freq Title'
end

Factory.define :probe_definition do |f|
  f.title 'Probe Title'
  f.description 'Probe Description'
end
